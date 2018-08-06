pragma solidity ^0.4.17;


contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public {
        address newlyDeployedCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newlyDeployedCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint approversCount; 
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient)
        public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
            //don't have to initialize reference type mapping approvals
        });
        
        requests.push(newRequest);
    }
    
    //votes yes on a pending request, by index
    function approveRequest(uint index) public {
        // use storage keyword - we want to directly examine the STORED request, not make a copy in memory
        Request storage request = requests[index];
        // Make sure this person has donated the amount to become a contributor
        require(approvers[msg.sender]);
        
        // Make sure this person hasn't voted
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    //manager sends a request's funds off to the recipient, by index
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        require(!request.complete);
        uint approvalThreshold = approversCount / 2;
        require(request.approvalCount > approvalThreshold);
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }
}