import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";

const tree = StandardMerkleTree.load(JSON.parse(fs.readFileSync("tree.json")));

for (const [i, v] of tree.entries()) {
  if (v[0] === "0x0000000000000000000000000000000000000001") {
    const proof = tree.getProof(i);
    console.log("Value:", v);
    console.log("Proof:", proof);
  }
}

// Value: [ '0x0000000000000000000000000000000000000001', '0' ]
// Proof: [
//   '0x50bca9edd621e0f97582fa25f616d475cabe2fd783c8117900e5fed83ec22a7c',
//   '0x8138140fea4d27ef447a72f4fcbc1ebb518cca612ea0d392b695ead7f8c99ae6',
//   '0x9005e06090901cdd6ef7853ac407a641787c28a78cb6327999fc51219ba3c880'
// ]