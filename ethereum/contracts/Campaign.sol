pragma solidity ^0.4.17;
contract CampaignFactory{
    address[] public deployedCampaigns;
    function createCampaign(uint minimum) public{
        address deployedCampaign = new Campaign(minimum,msg.sender);
        deployedCampaigns.push(deployedCampaign);
    }

    function getDeployedCampaigns() public view returns (address[]){
        return deployedCampaigns;
    }

}
contract Campaign{
   address public manager;
   uint public minimumContribution;
   mapping(address=>bool) public approvers;

   struct Request{
       string description;
       uint value;
       address recipient;
       bool complete;
       uint approvalCount;
       mapping(address=>bool) approvals;
   }

   uint public approversCount;

   Request[] public requests;

   modifier restricted(){
       require(msg.sender == manager);
       _;
   }

   function Campaign(uint minimum, address creator) public{
       manager = creator;
       minimumContribution = minimum;
   }

   function contribute() public payable {
       require(msg.value > minimumContribution);
       approvers[msg.sender] = true;
       approversCount++;
   }

   function createRequest(string description, uint value, address recipient) public restricted{
       //require(approvers[msg.sender]);

        Request memory newRequest = Request ({
           description:description,
           value:value,
           recipient:recipient,
           complete:false,
           approvalCount:0
       });

       requests.push(newRequest);

   }

   function approveRequest(uint index) public {
       Request storage myRequest = requests[index];
       require(approvers[msg.sender]);
       require(!myRequest.approvals[msg.sender]);

       myRequest.approvals[msg.sender] = true;
       myRequest.approvalCount++;
   }

   function finalizeRequest(uint index) public restricted{
       Request storage myRequest = requests[index];
       require(!myRequest.complete);
       require(myRequest.approvalCount > (approversCount /2));
       myRequest.recipient.transfer(myRequest.value);
       myRequest.complete = true;

   }

   function getSummary() public view returns(uint,uint,uint,uint,address){
     return (
       minimumContribution,
       this.balance,
       requests.length,
       approversCount,
       manager
     );
   }

   function getRequestsCount() public view returns (uint){
     return requests.length;
   }
}
