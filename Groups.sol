// SPDX-License-Identifier: GPL-3.0
// To Compile Run: solcjs --bin owner.sol
pragma solidity >=0.8.0 <0.9.0;

contract Groups(){
    // Privelage Ranking
    // 0 = No Privelage
    // 1 = Read Only
    // 2 = Assign Updates
    // 3 = Implement Updates
    // 4 = Create Groups and Assign Privelage
    // 5 = Owner
    private uint256 numMemebers

    struct Memeber{
        address adr;
        uint256 privelage;
    }
    mapping (uint => Group) private permissionsDirectory;

    constructor(uint _id) {
        premissionsDirectory[_id] = createMemeber(msg.sender, 5, _id);
    }
    
    function createMemeber(address _memeber, uint256 _privelage, uint256 _id) private {
        myDirectory[_id] = UpdateInfo(_checksum, _loc);
    }
    
}