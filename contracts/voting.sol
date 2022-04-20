// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract voting { 
    address public Owner;
    enum FAZ {
        preStart,
        start,
        end
    }
    
    FAZ public fazes;
    
    struct Candidate {
        uint8 id;
        uint8 countVote;
        string name;
    }
    struct Voter {
        string name;
        bool vote;
        uint candidDvotted;
    }

    uint8 Counter = 0 ;

    Candidate[] public candidate ;
    mapping(address => Voter) public voterInfo ;

    constructor (){
        Owner = msg.sender ;
        fazes = FAZ.preStart;
    }
    modifier onlyOwner(){
        require(Owner == msg.sender , "Only owner...");
        _;
    }

    function Changefaz(uint _code) public onlyOwner {
        if(_code == 1){
             fazes = FAZ.start; 
        }else{
            fazes = FAZ.end;
        }
    }
    function addCandidate(string memory _name) public onlyOwner{
        require(fazes == FAZ.preStart, " only preStart faze ");
        candidate.push(Candidate(Counter,0, _name));
        Counter++;

    }
    function VotingCandidate(string memory _name, uint _CandidaID) public{
        require(fazes == FAZ.start , "just work when faze is start"  );
        require(voterInfo[msg.sender].vote == false ,"only one can voted ");
        voterInfo[msg.sender] = Voter(_name,true,_CandidaID);
        candidate[_CandidaID].countVote++;
    }
    function winCandidate() public view returns(uint8 , string memory){
        require(fazes == FAZ.end ,"only end fazes ...");
        uint8 max = 0 ;
        uint8 winIndex = 0 ; 
        for(uint8 i = 0 ; i < candidate.length ; i++){
            if(candidate[i].countVote > max){
                max = candidate[i].countVote;
                winIndex = i ;
            }
        }
        return ( winIndex , candidate[winIndex].name ) ;
        
    }
    
}