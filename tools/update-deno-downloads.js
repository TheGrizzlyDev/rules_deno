import { createHash } from "https://deno.land/std@0.98.0/hash/mod.ts";


const cacheFile = Deno.args[0]

if (! cacheFile) {
    console.error("This script expects a JSON file as it's first argument")
    Deno.exit(1)
}

const lastUpdate = Date.now()

const cache = await Deno.readTextFile(cacheFile).then(JSON.parse)
const cachedReleases = cache.releases ||= {}

const releases = await fetch("https://api.github.com/repos/denoland/deno/releases").then(res => res.json())
for(const release of releases) {
    if (release.draft || release.prerelease) continue
    const version = release.name
    const cachedRelease = cachedReleases[version] ||= {}
    for (const asset of release.assets) {
        const url = asset["browser_download_url"]
        if (url.includes("src")) {
            //We do not need source archives
            continue
        }

        if (url.endsWith("lib.deno.d.ts")) {
            //We don't need the lib typings either
            continue
        }

        const urlComponents = url.split("/")
        const fileName = urlComponents[urlComponents.length - 1].split(".")[0]

        const [_, arch, _1, os] = fileName.split("-")

        if (! (arch && os)) {
            console.error(`Cannot find arch or os from the url ${url}`, arch, os)
            Deno.exit(1)
        }
        const cachedDownload = (cachedRelease[os] ||= {})[arch] ||= {}

        const assetLastUpdate = new Date(asset["updated_at"]) 
        const cacheEntryLastUpdate = cachedDownload.lastUpdate && new Date(cachedDownload.lastUpdate)
        const shouldRefresh = ! cacheEntryLastUpdate || (assetLastUpdate > cacheEntryLastUpdate)

        if (shouldRefresh) {
            console.log(`Refreshing cache entry for deno-${version} - ${arch}-${os} => ${url}`)
            cachedDownload.url = url
            cachedDownload.lastUpdate = lastUpdate

            
            const assetContent = await fetch(url).then(res => res.arrayBuffer())
            const hash = createHash("sha256");
            hash.update(assetContent)
            cachedDownload.sha256 = hash.toString()

        }
    }
}


cache.lastUpdate = lastUpdate

console.log(JSON.stringify(cache, null, 2))