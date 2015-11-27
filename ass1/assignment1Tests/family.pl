%       Here is the family tree
%
%           ---------- mA1 - wB1 ------        -- mD1 - wE1 --
%          /               |           \      /       |       \
%   wC1 - mA2        wD1- mA3         wA1 - mD2     mD3      wD1 - mA3
%   /      \         /      \        /     |    \
% mA4     wA2   mF1-wA3     wA4    wD2    wD3   mD4
%               /      \
%             mF2      wF1
male(mA1).
male(mA2).
male(mA3).
male(mA4).
male(mD1).
male(mD2).
male(mD3).
male(mD4).
male(mF1).
male(mF2).

% = These are the example given in the spec = %
male(jim).
male(brian).
female(pat).
female(jenny).
% =========================================== %

female(wA1).
female(wA2).
female(wA3).
female(wA4).
female(wB1).
female(wC1).
female(wD1).
female(wD2).
female(wD3).
female(wE1).
female(wF1).

% = These are the example given in the spec = %
parent(jim, brian).
parent(brian, jenny).
parent(pat, brian).
% =========================================== %

parent(mA1, mA2).
parent(mA1, mA3).
parent(mA1, wA1).
parent(wB1, mA2).
parent(wB1, mA3).
parent(wB1, wA1).

parent(mD1, mD2).
parent(mD1, mD3).
parent(mD1, wD1).
parent(wE1, mD2).
parent(wE1, mD3).
parent(wE1, wD1).

parent(mA2, mA4).
parent(mA2, wA2).
parent(wC1, mA4).
parent(wC1, wA2).

parent(mA3, wA3).
parent(mA3, wA4).
parent(wD1, wA3).
parent(wD1, wA4).

parent(mD2, wD2).
parent(mD2, wD3).
parent(mD2, mD4).
parent(wA1, wD2).
parent(wA1, wD3).
parent(wA1, mD4).

parent(mF1, mF2).
parent(mF1, wF1).
parent(wA3, mF2).
parent(wA3, wF1).
