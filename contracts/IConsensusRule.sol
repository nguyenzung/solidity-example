// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IConsensusRule {
    function isExistCandidate(address candidate) external returns (bool);
    function isAccepted(address candidate) external returns (bool);
    function vote(address voter, address candidate) external;
    function createProposal(address voter, address candidate) external;
}

