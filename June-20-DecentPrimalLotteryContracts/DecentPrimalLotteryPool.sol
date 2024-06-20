// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/*
    @author: ES_TAKASUGI
    
    @state variables:

*/

import "./Ownable.sol";
import "./SafeMath.sol";

contract DecentPrimalLotteryPool is Ownable {
    
    // use the safe math library
    using SafeMath32 for uint32;

    // initate pool related varaibales
    uint32 public currentPoolIndex = 0; 
    uint256 public poolOpenTime = 180 days; // each lottery pool will open for 180 days
    bool public isCurrentPoolExpired = false;

    // setup pool structure
    struct Pool {
        uint32 poolId;
        uint256 poolAccumulateInEther;
        uint256 poolStartTime;
        uint256 poolEndTime;
        string winnerUserName;
    }

    // data Base For pools
    Pool[] internal poolLedger;


    // this function give administrator privilage to start a new pool with restriction
    function createPool() public onlyOwner {

        require(currentPoolIndex == 0 || isCurrentPoolExpired == true); // the administor can only start a new pool if : 1, they are creating the first pool, 2. the current pool has expired
        
        uint256 startTime = block.timestamp + 777777777777 days; // until certain conditions are met, the pool won't start
        poolLedger.push(Pool(currentPoolIndex, 0, startTime, startTime + poolOpenTime, "")); // initiate a pool annd store its information to the lottery pool data base
        
        currentPoolIndex = currentPoolIndex.add(1); //safe math version of currentPoolIndex++
    }


    // this function give public access to the current pool information, non-users can also see this information
    function checkPoolInforamtion(uint32 _poolNumber) public view returns(uint32, uint256, uint256, uint256, string memory) {
        
        require(_poolNumber < currentPoolIndex, "the pool  you are checking is not available yet");
        return(poolLedger[_poolNumber].poolId, poolLedger[_poolNumber].poolAccumulateInEther, 
               poolLedger[_poolNumber].poolStartTime, poolLedger[_poolNumber].poolEndTime, 
               poolLedger[_poolNumber].winnerUserName);
    }

    
    // this function allow contract owner to extract remainings after prize distributed from the current lottery pool
    function withdrawFromCurrentPool() public onlyOwner {

        // after creation, the currentPoolIndex will increase by one for the creation of the next pool. To access the current one, simply do currentPoolIndex -1, the next one, currentPoolIndex
        require((isCurrentPoolExpired == true) && 
                (keccak256(abi.encodePacked(poolLedger[currentPoolIndex.sub(1)].winnerUserName)) != keccak256(abi.encodePacked(""))), "You can not withdraw from the pool before a winner exists");
        poolLedger[currentPoolIndex.sub(1)].poolAccumulateInEther = 0;

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }


    /*The functions below should be created in a later helper contracts that orchestrate user, pool, ticket and verifications */ 
    // function poolStart() public onlyOwner {
    //     // TO-DO: need to add check max user total cost, require poolAccumulateInEther > 3 times of that

    //     poolLedger[currentPoolIndex - 1].poolStartTime = block.timestamp; // after creation, the currentPoolIndex will increase by one for the creation of the next pool. To access the current one, simply do currentPoolIndex -1
    //     // Future TO-DO: need chainlink logic upkeep to automate this process
    // }

    // function endPool() public onlyOwner {
    //     require(block.timestamp >= poolLedger[currentPoolIndex - 1].poolEndTime); // after creation, the currentPoolIndex will increase by one for the creation of the next pool. To access the current one, simply do currentPoolIndex -1
    //     isCurrentPoolExpired = true;
    //     // TO-DO: findWinnner() 
    //     // Future TO-DO: need chainlink time upkeep to automate this process
    // }

}