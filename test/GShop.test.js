const { assert, expect } = require('chai');
const { ethers, network } = require('hardhat');
const { developmentChains } = require('../helper-hardhat-config');
const tokenJSON = require('../build/artifacts/contracts/GryvnaToken.sol/GryvnaToken.json');

!developmentChains.includes(network.name)
    ? describe.skip
    : describe('GShop', () => {
          let owner, buyer, shop, erc20;
          beforeEach(async function () {
              [owner, buyer] = await ethers.getSigners();
              const GShop = await ethers.getContractFactory('GShop', owner);
              shop = await GShop.deploy();
              await shop.deployed();

              erc20 = new ethers.Contract(await shop.token(), tokenJSON.abi, owner);
          });

          it('Should have an owner and a token', async function () {
              expect(await shop.getOwner()).to.eq(owner.address);
              //   assert(shop.getOwner(), owner.address);
              expect(await shop.token()).to.be.properAddress;
          });

          it('Should allow to buy some tokens', async () => {
              const tokenAmount = 100;
              const txData = {
                  value: tokenAmount,
                  to: shop.address,
              };

              const tx = await buyer.sendTransaction(txData);
              await tx.wait();

              expect(await erc20.balanceOf(buyer.address)).to.eq(tokenAmount);

              await expect(() => tx).to.changeEtherBalance(shop, tokenAmount);
              await expect(tx).to.emit(shop, 'Bought').withArgs(tokenAmount, buyer.address);
          });
          it('Should allows to sell', async () => {
              const txData = {
                  value: 100,
                  to: shop.address,
              };
              const tx = await buyer.sendTransaction(txData);
              await tx.wait();

              const sellAmount = 50;
              const approval = await erc20.connect(buyer).approve(shop.address, sellAmount);
              await approval.wait();

              const sellTx = await shop.connect(buyer).sell(sellAmount);
              expect(await erc20.balanceOf(buyer.address)).to.eq(50);

              await expect(() => sellTx).to.changeEtherBalance(shop, -sellAmount);
              await expect(sellTx).to.emit(shop, 'Sold').withArgs(sellAmount, buyer.address);
          });
      });
