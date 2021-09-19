// deploy code will go here
const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/CampaignFactory.json');
const provider = new HDWalletProvider(
  '' //put here the seed 
  'https://rinkeby.infura.io/v3/...' // put here your infura link
);
const web3 = new Web3(provider);

const deploy = async() => {
  const accounts = await web3.eth.getAccounts();
  console.log("Attempting to deploy from account", accounts[0]);
  const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({data:compiledFactory.bytecode})
    .send({gas:'1000000', from:accounts[0]});
  console.log(compiledFactory.interface);
  console.log("Contract deployed to", result.options.address);
}
// address del contratto creato su rinkeby: 0x989c9Be94a81A49aB41a799abEf20B3298bdaec2
deploy();
