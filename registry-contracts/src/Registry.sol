// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Registry is ERC721, Ownable {
    struct Asset {
        uint256 id;
        string ownerId;
        address ownerAddress;
    }

    mapping(uint256 tokenId => Asset) public assets;
    mapping(address assetOwner => uint256 tokenId) public owners;
    uint256 private _tokenIds;

    event AssetTransferred(address indexed previousOwner, address indexed newOwner, uint256 indexed tokenId);

    constructor() ERC721("RegistryProperties", "RPI") Ownable(msg.sender) {}

    /**
     * Create an asset and assign it to the asset owner.
     * Only the registry can create new assets.
     * @param ownerAddress The address of the asset owner
     * @param ownerId The id of the asset owner
     * @param assetId The id of the asset
     * @return tokenId The id of the newly created asset
     */
    function createAsset(address ownerAddress, string memory ownerId, uint256 assetId)
        external
        onlyOwner
        returns (uint256 tokenId)
    {
        tokenId = ++_tokenIds;
        _safeMint(ownerAddress, tokenId);
        assets[tokenId] = Asset({id: assetId, ownerId: ownerId, ownerAddress: ownerAddress});
        owners[ownerAddress] = tokenId;
    }

    /**
     * Transfer an asset to a new owner.
     * Only the current owner of the asset can transfer it to a new owner.
     * @param tokenId The id of the token to transfer (different from asset id)
     * @param newOwner The address of the new owner
     * @param newOwnerId The id of the new owner
     */
    function transferAsset(uint256 tokenId, address newOwner, string memory newOwnerId) external {
        require(ownerOf(tokenId) == msg.sender, "You don't own this asset");

        // Transfer the token to the new owner
        _safeTransfer(msg.sender, newOwner, tokenId);

        // Update asset ownership
        assets[tokenId].ownerAddress = newOwner;
        assets[tokenId].ownerId = newOwnerId;

        emit AssetTransferred(msg.sender, newOwner, tokenId);
    }

    /**
     * Verify the asset ownership by checking the asset ID and the borrower ID.
     * @param _borrower The address of the borrower
     * @param _assetId The id of the asset
     * @return borrowerOwnsAsset True if the borrower owns the asset, false otherwise
     */
    function verifyRequest(address _borrower, uint256 _assetId) external view returns (bool borrowerOwnsAsset) {
        uint256 tokenId = owners[_borrower];
        return assets[tokenId].id == _assetId;
    }

    function getAsset(address _borrower) public view returns (Asset memory){
        uint256 tokenId = owners[_borrower];
        return assets[tokenId];
    }
}
