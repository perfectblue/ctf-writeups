# Seven's Game - High

The free game combinations of A has five settings for the bonus game, and
The combinations of B has three settings. The bug is here, if we pick the 
4th/5th option of the combinations of A and then change the combinations
to B, still the index is fixed to 4th/5th, and it will start using some
values for recording purpose (out of bound!), and we can get huge points
from the bonus game.