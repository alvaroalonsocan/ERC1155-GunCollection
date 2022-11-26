// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract GunCollection is
    ERC1155,
    Ownable,
    Pausable,
    ERC1155Burnable,
    ERC1155Supply
{
    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;
    string public name;

    address private MINT_DESTINATION =
        0x274946079051139c35f12911966F00AB5200FD4e;

    // Modifiers
    modifier enoughResources(uint256 id) {
        if (id == 3) {
            require(
                balanceOf(msg.sender, 0) >= 1,
                "You dont have a barrel to build a m4a1"
            );
            require(
                balanceOf(msg.sender, 1) >= 1,
                "You dont have a body to build a m4a1"
            );
            require(
                balanceOf(msg.sender, 2) >= 1,
                "You dont have a butt to build a m4a1"
            );
        }
        _;
    }

    constructor(string memory _name)
        ERC1155(
            // nft storage
            "ipfs://bafybeift4gwjjisiwoij6eorvaxqdnl3src4qvvahuli3xxw4yi2wt3yai/{id}" 
            // pinata
            // "https://ipfs.io/ipfs/QmVMf4t7d5DjfgdB9pwL6kBWowFxN7jaVxSxQRewSWkrgy/{id}"
        )
    {
        name = _name;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public enoughResources(id) {
        _mint(account, id, amount, data);
        //check id y dependiendo de cual es hacemos burn de los tokens correspondientes
        if(id == 3){
            for(uint i = 0;i<amount;i++){
                _burn(account,0,1);
                _burn(account,1,1);
                _burn(account,2,1);
            }
        }
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
