//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Contract to manage a set of ERC721 tokens

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IERC721ERC20Protocols {

  function getMyBalance() external view returns (uint256 balance);
  function getMyBalance(uint256 protocolId) external view returns (uint256 balance);

  function balanceOf(address owner) external view returns (uint256 balance);
  function balanceOf(uint256 protocolId, address owner) external view returns (uint256 balance);

  function ownerOf(uint256 protocolId, uint256 tokenId) external view returns (address owner);

  // function transferMy(address to, uint256 tokenId) external returns (bool);
  function transferMy(uint256 protocolId, address to, uint256 tokenId) external returns (bool);

  // function safeTransferFrom(
  //       uint256 protocolId,
  //       address from,
  //       address to,
  //       uint256 tokenId,
  //       uint256 value
  //   ) external;
  
  // function safeTransferFrom(
  //       uint256 protocolId,
  //       address from,
  //       address to,
  //       uint256 tokenId,
  //       uint256 value,
  //       bytes calldata data
  //   ) external;

  // function transferFrom(
  //       uint256 protocolId,
  //       address from,
  //       address to,
  //       uint256 value,
  //       uint256 tokenId
  //   ) external;

  function approve(uint256 protocolId, address to, uint256 tokenId) external;

  function getApproved(uint256 protocolId, uint256 tokenId) external view returns (address operator);

  // function setApprovalForAll(address operator, bool _approved) external;
  function setApprovalForAll(uint256 protocolId, address operator, bool _approved) external;

  // function isApprovedForAll(uint256 protocolId, address owner, address operator) external view returns (bool);
}

contract ERC721ERC20Protocols is IERC721ERC20Protocols {

  mapping(address => uint256)[] private balances;
  mapping(uint256 => address)[] private owners;
  mapping(uint256 => address)[] private approved;

  modifier protocolExists(uint256 protocolId) {
    require(protocolId < balances.length, "protocolExists: The protocold with such ID doesn't exist");
    _;
  }

  modifier validAddress(address addr) {
    require(addr != address(0), "validAddress: zero address provided");
    _;
  }

  function getMyBalance() external view override returns (uint256 balance) {
    return this.balanceOf(msg.sender);
  }

  function getMyBalance(uint256 protocolId) external view override protocolExists(protocolId) returns (uint256 balance) {
    return balances[protocolId][msg.sender];
  }

  function balanceOf(address owner) external view override validAddress(owner) returns (uint256 balance) {
    for (uint i = 0; i < balances.length; i++) {
      balance += balances[i][owner];
    }
  }

  function balanceOf(uint256 protocolId, address owner)
  external
  view
  override
  protocolExists(protocolId)
  validAddress(owner)
  returns (uint256 balance) {
    return balances[protocolId][owner];
  }

  function ownerOf(uint256 protocolId, uint256 tokenId) external view override returns (address owner) {
    return owners[protocolId][tokenId];
  }

  // function transferMy(address to, uint256 tokenId) external override returns (bool) {
  // }

  function transferMy(uint256 protocolId, address to, uint256 tokenId)
  external
  override
  protocolExists(protocolId)
  validAddress(to)
  returns (bool) {
    mapping(uint256 => address) storage protoOwners = owners[protocolId];
    require(protoOwners[tokenId] == msg.sender, "transferMy: The sender is not the owner");
    protoOwners[tokenId] = to;
    return true;
  }

  modifier 

  function approve(uint256 protocolId, address to, uint256 tokenId)
  external
  override 
  protocolExists(protocolId)
  validAddress(to) {
    mapping(uint256 => address) storage protoApproved = approved[protocolId];
    require(protoApproved[tokenId] == msg.sender, "approve: The sender is not the owner");
    protoApproved[tokenId] = to;
  }

  function getApproved(uint256 protocolId, uint256 tokenId)
  external
  view
  override
  protocolExists(protocolId)
  returns (address operator) {
    return approved[protocolId][tokenId];
  }

  function setApprovalForAll(uint256 protocolId, address operator, bool _approved)
  external
  override 
  protocolExists(protocolId) 
  validAddress(operator){
    mapping(uint256 => address) storage protoApproved = approved[protocolId];
    require(protoApproved[tokenId] == msg.sender, "approve: The sender is not the owner");
    // ...
  }

}

contract ERC721Protocols {
  
  mapping(address => ERC721) protocols;

  function balanceOf(address nftContract, address owner) external view returns (uint256) {
    require(nftContract != address(0), "Call on zero-address contract");
    require(owner != address(0), "Owner can't be zero");
    
    ERC721 erc721Contract = protocols[nftContract];
    require(erc721Contract != ERC721(address(0)), "Such protocol is not registered");
    return erc721Contract.balanceOf(owner);
  }

  function getMyNFTBalance() external view returns (uint256) {
    
  }

  function getMyNFTContractBalance(address nftContract) external view returns (uint256) {
    require(msg.sender != address(0), "address is zero");
    require(nftContract != address(0), "Call on zero-address contract");
    return this.balanceOf(nftContract, msg.sender);
  }

}