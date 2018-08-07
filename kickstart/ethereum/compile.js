const path = require("path");
const fs = require("fs-extra");
const solc = require("solc");

const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath); //rm build path for clean build

const campaignPath = path.resolve(__dirname, "contracts", "Campaign.sol");
const source = fs.readFileSync(campaignPath, "utf8"); //read the contract
const compilerOutput = solc.compile(source, 1).contracts; //contains both the campaign and the campaignfactory

fs.ensureDirSync(buildPath);

//take each contract in compilerOutput and put it in build
for (let contract in compilerOutput) {
	outputPath = path.resolve(buildPath, contract.replace(":", "") + ".json");
	fs.outputJsonSync(outputPath, compilerOutput[contract]);
}
