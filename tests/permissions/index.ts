const filename = "./hello.txt"

await Deno.writeTextFile(filename, "Hello, world!");

const file = await Deno.open(filename);
await Deno.copy(file, Deno.stdout);
file.close();