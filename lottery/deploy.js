const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
	'divorce language elegant economy honey green trash estate pottery champion strategy extend',
	'https://rinkeby.infura.io/nU8tsH8kAWyCLEXxS4Wz'
);
const web3 = new Web3(provider);

const deploy = async () => {
	const accounts = await web3.eth.getAccounts();

	console.log('Attempting to deploy from account', accounts[0]);

	const deployResult = await new web3.eth.Contract(JSON.parse(interface))
		.deploy({
		data: '0x' + bytecode
		})
		.send({
			gas: '1000000',
			gasPrice: web3.utils.toWei('2','gwei'),
			from: accounts[0]
		});

	console.log(interface);
	console.log('Contract deployed to', deployResult.options.address);

};
deploy();