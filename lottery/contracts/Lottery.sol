pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;
    
    constructor() public {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }
    
    function random() private view returns (uint256) {
        return uint256(keccak256(block.difficulty, now, players));
        //sha3 is a specific implementation of keccak256
    }
    
    function pickWinner() public restricted {
        
        uint256 index = random() % players.length;
        address winner = players[index];
        address thisContractAddress = address(this);
        winner.transfer(thisContractAddress.balance);
        
        //reset array
        players = new address[](0);
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function getPlayers() public view returns (address[]){
        return players;
    }
}