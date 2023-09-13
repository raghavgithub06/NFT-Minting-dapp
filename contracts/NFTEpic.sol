//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract NFTEpic is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 private totalNumberOfTokens = 0;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Eren",
        "Armin",
        "Mikasa",
        "Annie",
        "Historia",
        "Jean",
        "Hange",
        "Levi",
        "Erwin",
        "Reiner",
        "Sasha",
        "Bertholdt",
        "Connie",
        "Zeke"
    ];
    string[] secondWords = [
        "Yeager",
        "Arlert",
        "Ackerman",
        "Braus",
        "Springer",
        "Kirschtein",
        "Smith",
        "Ackerman",
        "Zoe",
        "Braun",
        "Leonhart",
        "Hoover",
        "Reiss",
        "Yeager"
    ];
    string[] thirdWords = [
        "Kills",
        "Explores",
        "Cares",
        "Eats",
        "Dies",
        "Farts",
        "IsAHorse",
        "Strategizes",
        "IsShort",
        "IsCreepy",
        "IsDepressed",
        "Sleeps",
        "IsEaten",
        "Queen",
        "Monke"
    ];

    event NFTMinted(address minter, uint256 tokenNum);

    constructor() ERC721("ShingekiNoKyojinNFT", "AOTNFT") {
        console.log("AOT NFT minter!");
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        require(
            _tokenIds.current() < 100,
            "Only a hundred tokens can be minted"
        );
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of AOT characters", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log(finalTokenUri);

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        totalNumberOfTokens += 1;
        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NFTMinted(msg.sender, newItemId);
    }

    function totalTokens() public view returns (uint256) {
        return totalNumberOfTokens;
    }
}
