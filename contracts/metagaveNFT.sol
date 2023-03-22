// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, ERC721URIStorage, Pausable, Ownable, ERC721Burnable, AccessControl {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public maxMintsPerTx = 1;


    bytes32 public constant MARKETPLACE_ROLE = keccak256("MARKETPLACE_ROLE");

    constructor(address _marketplaceContract) ERC721("MyToken", "MTK") {
        _setupRole(DEFAULT_ADMIN_ROLE, _marketplaceContract);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string[] memory uris) public {
        require(hasRole(MARKETPLACE_ROLE, _msgSender()), "MyToken: must have marketplace role to mint");

        uint256 numTokens = uris.length;
        require(numTokens <= maxMintsPerTx, "MyToken: max mints per tx exceeded");

        for (uint256 i = 0; i < numTokens; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, uris[i]);
        }
    }

    function setMaxMintsPerTx(uint256 _maxMintsPerTx) public onlyOwner {
        maxMintsPerTx = _maxMintsPerTx;
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(hasRole(MARKETPLACE_ROLE, _msgSender()), "MyToken: must have marketplace role to transfer");
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
        require(hasRole(MARKETPLACE_ROLE, _msgSender()), "MyToken: must have marketplace role to transfer");
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
        require(hasRole(MARKETPLACE_ROLE, _msgSender()), "MyToken: must have marketplace role to transfer");
        super.safeTransferFrom(from, to, tokenId, _data);
    }

    function grantMarketplaceRole(address marketplace) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(MARKETPLACE_ROLE, marketplace);
    }

    function revokeMarketplaceRole(address marketplace) public onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(MARKETPLACE_ROLE, marketplace);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
