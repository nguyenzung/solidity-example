// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ConsensusResult, IConsensusRule } from "./IConsensusRule.sol";

interface ICommunity {
    function members(address addr) external returns (bool);
    function memberProposals(address candidate) external returns (address);
    function population() external returns (uint256);
    function currentRuleConsesus() external returns (address);
}

contract Community is ICommunity {

    mapping(address => bool) public override members;

    // mapping rule address to vote count for the rule
    mapping(address => uint256) public ruleProposals;

    // Vote history of an address to rule-addresses
    mapping(address => mapping(address => bool)) voteChangeRuleHistory;

    // mapping candidate user to consensus rule
    mapping(address => address) public override memberProposals;

    // total members in community
    uint256 public override population;

    // current consensus contract address
    address public override currentRuleConsesus;

    // current candidate consensus contract address
    address public currentCandidateRuleConsesus;
    
    event AddedMember(address indexed newMember);
    
 
    constructor() {
        addNewMember(msg.sender);
    }

    modifier isMember() {
        require(members[msg.sender], "Member Permission");
        _;
    }

    function voteNewRule(address newRule) external isMember{
        require(!voteChangeRuleHistory[msg.sender][newRule], "msg.sender has voted this rule");
        require(currentRuleConsesus != newRule, "New Rule is Current Rule");
        if (currentCandidateRuleConsesus != newRule) {
            delete ruleProposals[currentCandidateRuleConsesus];
            currentCandidateRuleConsesus = newRule;
        }
        ruleProposals[newRule] += 1;
        voteChangeRuleHistory[msg.sender][newRule] = true; // msg.sender voted this rule
    }

    function confirmNewRule(address newRule) external {
        require (ruleProposals[newRule] > population >> 1, "Can not change rule consensus");
        delete ruleProposals[currentRuleConsesus];
        currentRuleConsesus = newRule;
    }

    function proposeNewMember(address candidate) external isMember {
        require(!members[candidate], "The candidate is already a member");
        require(memberProposals[candidate] == address(0), "This candidate has been proposed");
        createMemberProposal(candidate);
    }

    function createMemberProposal(address candidate) internal isMember {
        memberProposals[candidate] = currentRuleConsesus;
        IConsensusRule(memberProposals[candidate]).createProposal(msg.sender, candidate);
    }

    function voteNewMember(address candidate) public isMember {
        require(IConsensusRule(memberProposals[candidate]).isExistCandidate(candidate), "CANDIDATE EXIST");
        IConsensusRule(memberProposals[candidate]).vote(msg.sender, candidate);
    }

    function addNewMember(address candidate) internal {
        population += 1;
        members[candidate] = true;
        emit AddedMember(candidate);
    } 

    function claimMembership() public {
        require (IConsensusRule(memberProposals[msg.sender]).isAccepted(msg.sender), "INVALID CLAIM MEMBERSHIP");
        addNewMember(msg.sender);
    }
}