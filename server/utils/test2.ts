import * as fs from "fs";
import sharp from "sharp";

// Function to convert Base64 to an image file
async function convertBase64ToImage(
  base64Data: string,
  outputFilePath: string
) {
  await sharp(Buffer.from(base64Data, "binary")).toFile(outputFilePath);
  console.log("Image file created successfully!");
}

class Node {
  symbol: string | null;
  frequency: number;
  left: Node | null;
  right: Node | null;

  constructor(symbol: string | null, frequency: number) {
    this.symbol = symbol;
    this.frequency = frequency;
    this.left = null;
    this.right = null;
  }
}

function buildFrequencyTable(data: string): Record<string, number> {
  const frequencyTable: Record<string, number> = {};

  for (const symbol of data) {
    if (frequencyTable[symbol]) {
      frequencyTable[symbol]++;
    } else {
      frequencyTable[symbol] = 1;
    }
  }

  return frequencyTable;
}

function buildHuffmanTree(frequencyTable: Record<string, number>): Node {
  const nodes: Node[] = [];

  for (const symbol in frequencyTable) {
    nodes.push(new Node(symbol, frequencyTable[symbol]));
  }

  while (nodes.length > 1) {
    nodes.sort((a, b) => a.frequency - b.frequency);
    const left = nodes.shift()!;
    const right = nodes.shift()!;
    const parent = new Node(null, left.frequency + right.frequency);
    parent.left = left;
    parent.right = right;
    nodes.push(parent);
  }

  return nodes[0];
}

function buildCodeMap(huffmanTree: Node): Record<string, string> {
  const codeMap: Record<string, string> = {};

  function traverse(node: Node, code: string) {
    if (node.symbol) {
      codeMap[node.symbol] = code;
    } else {
      traverse(node.left!, code + "0");
      traverse(node.right!, code + "1");
    }
  }

  traverse(huffmanTree, "");

  return codeMap;
}

function encodeData(data: string, codeMap: Record<string, string>): string {
  let encodedData = "";

  for (const symbol of data) {
    encodedData += codeMap[symbol];
  }

  return encodedData;
}

export function compressImg(inputFilePath: string, outputFilePath: string) {
  // Read input image file as binary data
  const inputData = fs.readFileSync(inputFilePath);

  // Convert binary data to Base64 string
  const base64Data = inputData.toString("base64");

  // Build frequency table from Base64 data
  const frequencyTable = buildFrequencyTable(base64Data);

  // Construct Huffman tree
  const huffmanTree = buildHuffmanTree(frequencyTable);

  // Build code map
  const codeMap = buildCodeMap(huffmanTree);

  // Encode Base64 data
  const encodedData = encodeData(base64Data, codeMap);

  // Convert encoded data to binary buffer
  const compressedData = Buffer.from(encodedData, "binary");

  // Convert binary data to Base64 string
  const compressedBase64Data = compressedData.toString();

  convertBase64ToImage(compressedBase64Data, outputFilePath);
  // fs.writeFileSync(outputFilePath, compressedBase64Data, {
  //   encoding: "base64",
  // });
}
