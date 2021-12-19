// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IConsensusRule } from "./IConsensusRule.sol";
import { ICommunity } from "./Community.sol";

contract HalfOfTotalRule is IConsensusRule {

    address public community;

    // mapping candidate to vote count of the candidate
    mapping(address => uint256) public voteCountForCandidate;

    // Vote history of an address to candidates
    mapping(address => mapping(address => bool)) voteHistory;

    constructor (address _community) {
        community = _community;
    }

    function isExistCandidate(address candidate) external override view returns (bool) {
        return voteCountForCandidate[candidate] > 0;
    }

    function isAccepted(address candidate) external override returns (bool) {
        return voteCountForCandidate[candidate] > (ICommunity(community).population() >> 1);
    }

    function vote(address voter, address candidate) override public {
        require(!voteHistory[voter][candidate], "Voter has voted candidate");
        voteCountForCandidate[candidate] += 1;
        voteHistory[voter][candidate] = true;
    }

    function createProposal(address voter, address candidate) override external {
        vote(voter, candidate);
    }
}