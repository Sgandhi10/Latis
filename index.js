console.clear();
require("dotenv").config();
const {
	AccountId,
	PrivateKey,
	Client,
	FileCreateTransaction,
	ContractCreateTransaction,
	ContractFunctionParameters,
	ContractExecuteTransaction,
	ContractCallQuery,
	Hbar,
	ContractCreateFlow,
} = require("@hashgraph/sdk");
const fs = require("fs");

// Configure accounts and client
const operatorId = AccountId.fromString(process.env.MY_ACCOUNT_ID);
const operatorKey = PrivateKey.fromString(process.env.MY_PRIVATE_KEY);

const client = Client.forTestnet().setOperator(operatorId, operatorKey);

async function main() {
	// Import the compiled contract bytecode
	const contractBytecode = fs.readFileSync("LookupContract_sol_LookupContract.bin");

	// Instantiate the smart contract
	const contractInstantiateTx = new ContractCreateFlow()
		.setBytecode(contractBytecode)
		.setGas(1000000)
		.setConstructorParameters(
			new ContractFunctionParameters()
		);
	const contractInstantiateSubmit = await contractInstantiateTx.execute(client);
	const contractInstantiateRx = await contractInstantiateSubmit.getReceipt(client);
	const contractId = contractInstantiateRx.contractId;
	const contractCost = contractInstantiateRx.exchangeRate.hbars;
	const contractAddress = contractId.toSolidityAddress();
	console.log(`- The smart contract ID is: ${contractId} \n`);
	console.log(`- The smart contract ID in Solidity format is: ${contractAddress} \n`);
	console.log('- The cost to create the smart contract is: ' + contractCost + ' Hbars \n');

	// Call contract function to update the state variable
	const contractExecuteTx = new ContractExecuteTransaction()
		.setContractId(contractId)
		.setGas(100000)
		.setFunction(
			"setUpdateInfo",
			new ContractFunctionParameters().addUint256(34).addUint256(17).addString("Test2")
		);
	const contractExecuteSubmit = await contractExecuteTx.execute(client);
	const contractExecuteRx = await contractExecuteSubmit.getReceipt(client);
	const getCost = contractExecuteRx.exchangeRate.hbars;
	console.log(`- Contract function call status: ${contractExecuteRx.status} \n`);
	console.log('- The cost to call the smart contract function is: ' + getCost + ' Hbars \n');

	// Query the contract to check changes in state variable
	const contractQueryTx1 = new ContractCallQuery()
		.setContractId(contractId)
		.setGas(100000)
		.setFunction("getUpdateInfo", new ContractFunctionParameters().addUint256(34));
	const contractQuerySubmit1 = await contractQueryTx1.execute(client);
	const contractQueryResult3 = contractQuerySubmit1.getUint256(0);
	const contractQueryResult4 = contractQuerySubmit1.getString(1);
	console.log('- Here\'s the sha256 that you asked for: ' + contractQueryResult3.toString() + '\n');
	console.log('- Here\'s the link that you asked for: ' + contractQueryResult4 +  '\n');
}
main();