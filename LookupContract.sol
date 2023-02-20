// SPDX-License-Identifier: GPL-3.0
// To Compile Run: solcjs --bin LookupContract.sol
pragma solidity >=0.7.0 <0.9.0;


contract LookupContract {

    struct UpdateInfo{
        uint256 checksum;
        string loc;
    }

    mapping (uint => UpdateInfo) myDirectory;

    function setUpdateInfo(uint _id, uint256 _checksum, string memory _loc) public {
            myDirectory[_id] = UpdateInfo(_checksum, _loc);
        }

    function getUpdateInfo(uint _id) public view returns (uint256, string memory) {
            return (myDirectory[_id].checksum, myDirectory[_id].loc);
        }
}