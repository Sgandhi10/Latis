// SPDX-License-Identifier: GPL-3.0
// To Compile Run: solcjs --bin LookupContract.sol
pragma solidity >=0.8.0 <0.9.0;

// Information on OpenZeppelin Contracts can be found at: https://docs.openzeppelin.com/contracts/4.x/access-control
import "openzeppelin-contracts-release-v4.8/contracts/access/AccessControl.sol";
import "openzeppelin-contracts-release-v4.8/contracts/token/ERC20/ERC20.sol";

contract ManufacturerContract is ERC20, AccessControl {
    bytes32 public constant ASSIGN_UPDATE = 0x293ac1473af20b374a0b048d245a81412cd467992bf656b69382c50f310e9f8c;
    bytes32 public constant VIEW_UPDATE = 0x4acc1d14ea2d6e85862a81bf8d5c1251286193eed6e3b81aab32a560eecea7ff;
    bytes32 public constant IMPLEMENT_UPDATE = 0x02ab26f719f5550031a1a942ddcb6b91a1c5b98639464444f1bb36c8a35efc27;
    bytes32 public constant ADMIN = 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42;
    bytes32 public constant OWNER = 0x6270edb7c868f86fda4adedba75108201087268ea345934db8bad688e1feb91b;

    string private _errorMessage = "No Permission";

    struct UpdateInfo {
        uint256 checksum;
        fileCoin loc;
    }

    struct fileCoin {
        uint128 minerId;
        address CID;
        address userAddress;
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
        uint128 _minerId,
        address _CID,
        address _userAddress
    ) public {
        require(
            hasRole(ASSIGN_UPDATE, msg.sender),
            _errorMessage
        );
        myDirectory[_to] = UpdateInfo(
            _checksum,
            fileCoin(_minerId, _CID, _userAddress)
        );
        pendingUpdates.push(_to);
    }

    function viewUpdates()
        public
        view
        returns (address[] memory _pendingUpdates)
    {
        require(
            hasRole(VIEW_UPDATE, msg.sender),
            _errorMessage
        );
        return (pendingUpdates);
    }

    function implementUpdate(
        address _id
    ) public view returns (uint256, uint128, address, address) {
        require(
            hasRole(IMPLEMENT_UPDATE, msg.sender),
            _errorMessage
        );
        return (
            myDirectory[_id].checksum,
            myDirectory[_id].loc.minerId,
            myDirectory[_id].loc.CID,
            myDirectory[_id].loc.userAddress
        );
    }

    function successUpdate(address _id) public {
        require(
            hasRole(IMPLEMENT_UPDATE, msg.sender),
            _errorMessage
        );
        delete myDirectory[_id];
    }

    function failUpdate(address _id) public {
        require(
            hasRole(IMPLEMENT_UPDATE, msg.sender),
            _errorMessage
        );
        failedUpdates.push(_id);
    }

    function grantAdmin(address _to) public {
        require(
            hasRole(OWNER, msg.sender),
            _errorMessage
        );
        _grantRole(ADMIN, _to);
    }

    function grantPermission(address _to, bytes32 _permission) public {
        require(
            hasRole(ADMIN, msg.sender),
            _errorMessage
        );
        _grantRole(_permission, _to);
    }

    function revokeAdmin(address _to) public {
        require(
            hasRole(OWNER, msg.sender),
            _errorMessage
        );
        _revokeRole(ADMIN, _to);
    }

    function revokePermission(address _to, bytes32 _permission) public {
        require(
            hasRole(ADMIN, msg.sender),
            _errorMessage
        );
        _revokeRole(_permission, _to);
    }
}
