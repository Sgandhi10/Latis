// SPDX-License-Identifier: GPL-3.0
// To Compile Run: solcjs --bin LookupContract.sol
pragma solidity >=0.8.0 <0.9.0;

// Information on OpenZeppelin Contracts can be found at: https://docs.openzeppelin.com/contracts/4.x/access-control
import "node_modules/@openzeppelin/contracts/access/AccessControl.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ManufacturerContract is ERC20, AccessControl {
    bytes32 public constant ASSIGN_UPDATE = keccak256("ASSIGN_UPDATE");
    bytes32 public constant VIEW_UPDATE = keccak256("VIEW_UPDATE");
    bytes32 public constant IMPLEMENT_UPDATE = keccak256("IMPLEMENT_UPDATE");
    bytes32 public constant ADMIN = keccak256("ADMIN");
    bytes32 public constant OWNER = keccak256("OWNER");

    struct UpdateInfo {
        uint256 checksum;
        string loc;
    }

    mapping(address => UpdateInfo) private myDirectory;
    address[] private pendingUpdates;
    address[] private failedUpdates;

    constructor() ERC20("MyToken", "TKN") {
        _grantRole(OWNER, msg.sender);
    }

    function assignUpdate(
        address _to,
        uint256 _checksum,
        string memory _loc
    ) public {
        require(
            hasRole(ASSIGN_UPDATE, msg.sender),
            "Caller doesn't have permission to assign update"
        );
        myDirectory[_to] = UpdateInfo(_checksum, _loc);
        pendingUpdates.push(_to);
    }

    function viewUpdates() public view returns (address[] memory _pendingUpdates) {
        require(
            hasRole(VIEW_UPDATE, msg.sender),
            "Caller doesn't have permission to view update"
        );
        return (pendingUpdates);
    }

    function implementUpdate(address _id) public view returns (uint256, string memory){
        require(
            hasRole(IMPLEMENT_UPDATE, msg.sender),
            "Caller doesn't have permission to implement update"
        );
        return (myDirectory[_id].checksum, myDirectory[_id].loc);
    }

    function successUpdate(address _id) public {
        require(
            hasRole(IMPLEMENT_UPDATE, msg.sender),
            "Caller doesn't have permission to implement update"
        );
        delete myDirectory[_id];
    }

    function failUpdate(address _id) public {
        require(
            hasRole(IMPLEMENT_UPDATE, msg.sender),
            "Caller doesn't have permission to implement update"
        );
        failedUpdates.push(_id);
    }

    function grantAdmin(address _to) public {
        require(
            hasRole(OWNER, msg.sender),
            "Caller doesn't have permission to grant role"
        );
        _grantRole(ADMIN, _to);
    }

    function grantAssignUpdate(address _to) public {
        require(
            hasRole(ADMIN, msg.sender),
            "Caller doesn't have permission to grant role"
        );
        _grantRole(ASSIGN_UPDATE, _to);
    }

    function grantViewUpdate(address _to) public {
        require(
            hasRole(ADMIN, msg.sender),
            "Caller doesn't have permission to grant role"
        );
        _grantRole(VIEW_UPDATE, _to);
    }

    function grantImplementUpdate(address _to) public {
        require(
            hasRole(ADMIN, msg.sender),
            "Caller doesn't have permission to grant role"
        );
        _grantRole(IMPLEMENT_UPDATE, _to);
    }

    function revokeAdmin(address _to) public {
        require(
            hasRole(OWNER, msg.sender),
            "Caller doesn't have permission to revoke role"
        );
        _revokeRole(ADMIN, _to);
    }

    function revokeAssignUpdate(address _to) public {
        require(
            hasRole(ADMIN, msg.sender),
            "Caller doesn't have permission to revoke role"
        );
        _revokeRole(ASSIGN_UPDATE, _to);
    }

    function revokeViewUpdate(address _to) public {
        require(
            hasRole(ADMIN, msg.sender),
            "Caller doesn't have permission to revoke role"
        );
        _revokeRole(VIEW_UPDATE, _to);
    }

    function revokeImplementUpdate(address _to) public {
        require(
            hasRole(ADMIN, msg.sender),
            "Caller doesn't have permission to revoke role"
        );
        _revokeRole(IMPLEMENT_UPDATE, _to);
    }
}
