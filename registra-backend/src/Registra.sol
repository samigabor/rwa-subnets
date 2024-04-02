// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Registra is ERC721URIStorage, Ownable {
    //Only registra can mint a Nft Property Token 
    uint256 public _requestIds;
    uint256 private _tokenIds;


    struct RwaVerificationRequest {
        string property_type;
        string description;
        uint256 value; // Value can be in Wei or other denomination
        address p_owner; // Address of the current property owner
        uint256 property_RegId;
        uint256 survey_zip_code;
        uint256 survey_number;
        bool verified;
    }

    // Mapping to store asset details by token ID
    mapping(address => mapping(uint256 => RwaVerificationRequest)) public assets;

    // Event to log asset transfer
    event AssetTransferred(address indexed previousOwner, address indexed newOwner, uint256 indexed tokenId);

    constructor() ERC721("RegistraProperties", "RPI") Ownable(msg.sender) {}

    function awardItem(address player, string memory tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 newItemId = _tokenIds;
        _mint(player, _tokenIds);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds++;
        return (_tokenIds - 1);
    }

    function verification_request(
        address _borrower,
        uint256 _property_RegId,
        uint256 _survey_zip_code,
        uint256 _survey_number,
        string memory _property_type
        
    ) 
        external 
        returns (bool success)
    {

        assets[msg.sender][_requestIds].property_type = _property_type;
        assets[msg.sender][_requestIds].p_owner = _borrower;
        assets[msg.sender][_requestIds].property_RegId = _property_RegId;
        assets[msg.sender][_requestIds].survey_zip_code = _survey_zip_code;
        assets[msg.sender][_requestIds].survey_number = _survey_number;
        _requestIds++;
        return true;
    }


    function transferAsset(uint256 tokenId, address newOwner, address oldOwner) external {
        // Check if the caller is the current owner of the asset
        require(ownerOf(tokenId) == msg.sender, "You don't own this asset");

        // Transfer the token to the new owner
        _transfer(msg.sender, newOwner, tokenId);

        // Update asset ownership
        assets[oldOwner][tokenId].p_owner = newOwner;

        // Emit event
        emit AssetTransferred(msg.sender, newOwner, tokenId);
    }



}

