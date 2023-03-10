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
	PublicKey
} = require("@hashgraph/sdk");
const fs = require("fs");

// Configure accounts and client
const operatorId = AccountId.fromString(process.env.MY_ACCOUNT_ID);
const operatorKey = PrivateKey.fromString(process.env.MY_PRIVATE_KEY);

const client = Client.forTestnet().setOperator(operatorId, operatorKey);

async function main() {
	// Import the compiled contract bytecode
	const contractBytecode = fs.readFileSync("ManufacturerContract_sol_ManufacturerContract.bin");

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

	// Call contract to add assign update permissions
	const contractExecuteTx3 = new ContractExecuteTransaction()
		.setContractId(contractId)
		.setGas(1000000)
		.setFunction(
			"grantPermission",
			new ContractFunctionParameters().addAddress(process.env.MY_PUBLIC_KEY).addUint8(0x02)
		);
	const contractExecuteSubmit3 = await contractExecuteTx3.execute(client);
	const contractExecuteRx3 = await contractExecuteSubmit3.getReceipt(client);
	console.log(`- Contract function call status: ${contractExecuteRx3.status} \n`);

	// Call contract to add view permissions
	const contractExecuteTx4 = new ContractExecuteTransaction()
		.setContractId(contractId)
		.setGas(1000000)
		.setFunction(
			"grantPermission",
			new ContractFunctionParameters().addAddress(process.env.MY_PUBLIC_KEY).addUint8(0x01)
		);
	const contractExecuteSubmit4 = await contractExecuteTx4.execute(client);
	const contractExecuteRx4 = await contractExecuteSubmit4.getReceipt(client);
	console.log(`- Contract function call status: ${contractExecuteRx4.status} \n`);
	
	
	// Call contract function to update the state variable
	const contractExecuteTx = new ContractExecuteTransaction()
		.setContractId(contractId)
		.setGas(1000000)
		.setFunction(
			"assignUpdate",
			new ContractFunctionParameters().addAddress(process.env.MY_PUBLIC_KEY).addUint256(0x34).addUint256(0xff32).addAddress(process.env.MY_PUBLIC_KEY).addAddress(process.env.MY_PUBLIC_KEY)
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
		.setFunction("implementUpdate", new ContractFunctionParameters().addAddress(process.env.MY_PUBLIC_KEY));
	const contractQuerySubmit1 = await contractQueryTx1.execute(client);
	const checksum = contractQuerySubmit1.getUint256(0);
	console.log(`- The checksum is: ${checksum} \n`);
	const minerId = contractQuerySubmit1.getUint256(1);
	console.log(`- The miner ID is: ${minerId} \n`);
	const CID = contractQuerySubmit1.getAddress(2);
	console.log(`- The CID is: ${CID} \n`);
	const userAddress = contractQuerySubmit1.getAddress(3);
	console.log(`- The user address is: ${userAddress} \n`);
}
main();