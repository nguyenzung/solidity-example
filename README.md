# solidity-learning

I made a simple contract to manage a community.

The community has 3 properties:
1. The first member of the community is the contract creator.
2. Can another members to the community. Every member of the community can vote for accepting new member (candidate). If the vote's result satify a consensus rule in community, the candidate can join community.
3. The community can change the consensus rule if more than 50% of members agree to make change.

I also created 3 sol files.
1. Community.sol manages community
2. IConsensusRule.sol define functions that every consensus rule contract need to implement
3. HalfOfTotalRule.sol: If more than 50% user agree to accept a candidate, the candidate can join the community
