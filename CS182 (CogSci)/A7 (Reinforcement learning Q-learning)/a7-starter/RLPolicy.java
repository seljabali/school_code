import java.util.HashMap;

/**
 * A reinforcement learning policy. This should be able to compute best actions.
 * You may also find it useful to store other data here.
 */
public class RLPolicy {
	RLWorld world;
	RLearner learner;

	class MatrixKey{
		int[]state; int action;
		int bx, by;
		MatrixKey(int[]stateness, int actionness, MonsterAndKnightWorld world){
			state = stateness;
			action = actionness;
			bx = world.bx;
			by = world.by;
		}
		public int hashCode(){
			int stateNum = 0;
			int BASE = Math.max(bx, by); // optimal: max value of x or y coord
			for (int i = 0; i < this.state.length; i++){
				stateNum += Math.pow(BASE, i) * state[i];
			}
			return ((action * (int)Math.pow(BASE, state.length)) | stateNum);
		}
		public boolean equals(Object o){
			MatrixKey m = (MatrixKey) o;
			if (this.action != m.action || this.state.length != m.state.length)
				return false;
			for (int i = 0; i < this.state.length; i++)
				if (this.state[i] != m.state[i])
					return false;
			return true;
		}
	}

	int actions;
	double reward;

	/** Q hashMap: Key -> (State, Action), Value -> Value */
	HashMap<MatrixKey, Double> Q = new HashMap<MatrixKey,Double>(); 

	/** R hashMap: Key -> (State, Action), Value -> Reward */	
	HashMap<MatrixKey, Double> R = new HashMap<MatrixKey,Double>();

	RLPolicy(int[] dimSize, RLearner learner) {
		this.world = learner.thisWorld;
		this.learner = learner;
		actions = dimSize[dimSize.length-1];
//		actions = 8;
	}

	public int getBestAction(int[] state) {
		double bestQ = 0, sample, curQ = 0, qMax = 0.;
		int [] nextState;
    	int bestAction = 0;
    	boolean firstTime = true;
    	for (int i = 0; i < actions; i++){
    		if (world.validAction(i)){
    			MatrixKey key = new MatrixKey(state, i, (MonsterAndKnightWorld)world);
    			if (! R.containsKey(key)){
    				reward = computeReward(state);
    				if (reward != 0)
    					R.put(key, reward);
    			}
    			else {
    				reward = R.get(key);
    				System.out.println("R table accessed " +  R.size() + "action = " + i);
    			}
    			nextState = getNewState(state, i);
    			qMax = getQMax(nextState);
    			sample = reward + learner.gamma * qMax;
    			if (! Q.containsKey(key))
    				curQ = 0;
    			else {
    				curQ = Q.get(key);
    				System.out.println("Q table accessed " +  Q.size()+ "action = " + i);
    			}
    			curQ = curQ + learner.alpha * (sample - curQ);
    			curQ = sample;
    			if (firstTime){
    				bestQ = curQ;
    				bestAction = i;
    				firstTime = false;
    			}
    			else if (curQ > bestQ){
    				bestQ = curQ;
    				bestAction = i;
    			}
    		}
    	}
    	MatrixKey bestKey = new MatrixKey(state, bestAction, (MonsterAndKnightWorld)world);
    	if (Q.containsKey(bestKey))
    		Q.remove(bestKey);
    	Q.put(bestKey, bestQ);
		return bestAction;
    }
	private int computeReward(int[] state){
		if (state[0]==state[2] && state[1]==state[3])
			return -((MonsterAndKnightWorld)world).deathPenalty;
		if (state[0]==state[4] && state[1]==state[5])
			return ((MonsterAndKnightWorld)world).treasureReward;
		return 0;
	}
    private int[] getNewState(int[] state, int action) { //our method: gets the new state resulting from applying the action on state
    	int[] changeInCoords = actionToDimensions(action);
    	int dx = changeInCoords[0], dy = changeInCoords[1];
    	int monsterX = state[2], monsterY = state[3], goldX = state[4], goldY = state[5];
    	int newKnightX = state[0] + dx,
    		newKnightY = state[1] + dy;
    		
    	int	yDisplacement = newKnightY - monsterY; //find where the monster needs to move
    	int xDisplacement = newKnightX - monsterX;
    	int	mdy = 0, mdx = 0;
    	
		//find mdx and mdy, the monster's dx and dy    		
		if (yDisplacement == 0)  //find mdy
			mdy = 0;
		else if (yDisplacement < 0)
			mdy = -1;
		else
			mdy = 1;
		
		if (xDisplacement == 0) //find mdx
			mdx = 0;
		else if (xDisplacement < 0)
			mdx = -1;
		else
			mdx = 1;
		
		int newMonsterX = monsterX + mdx,
			newMonsterY = monsterY + mdy;
		
		//make new state now
		int[] newState = {newKnightX, newKnightY, newMonsterX, newMonsterY, goldX, goldY};
		return newState;
    }
    private double getQMax(int[] nextState){ //look into the Q table and get the maximum value of this state's row in the table
    	boolean firstTime = true;
    	double highestQ = -1, currentQ;
    	MatrixKey key;
    	
    	for (int i = 0; i < actions; i++){
    		key = new MatrixKey(nextState, i, (MonsterAndKnightWorld)world);
    		if (Q.containsKey(key))
    			 currentQ = Q.get(key);
    		else { //if Q doesn't contain the key, initialize it to 0
    			currentQ = 0;
    		}
    		if (firstTime){
				highestQ = currentQ;
				firstTime = false;
			}
			else if (currentQ > highestQ){
				highestQ = currentQ;
			}
    	}
    	return highestQ;
    }
    
    private int[] actionToDimensions(int action){ // returns (dx, dy) resulting from action
    	int dx = 0, dy = 0;
    
    	switch (action){
    	case 0: //up
    		dx = 0;
    		dy = 1;
    		break;
    	case 1: //up right
    		dx = 1;
    		dy = 1;
    		break;
    	case 2: //right
    		dx = 1;
    		dy = 0;
    		break;
    	case 3: //down right
    		dx = 1;
    		dy = -1;
    		break;
    	case 4: //down
    		dx = 0;
    		dy = -1;
    		break;
    	case 5: //down left
    		dx = -1;
    		dy = -1;
    		break;
    	case 6: //left
    		dx = -1;
    		dy = 0;
    		break;
    	case 7: //up left
    		dx = -1;
    		dy = 1;
    		break;
    	default:
    		System.out.println("We got oursleves a weird action here! There are " + actions + " actions\n");
    	}
    	int[] coords = {dx, -dy};
    	return coords;
    }
    private double computeR(int[] state, int action){
    	int dx = 0, dy = 0, 
    		newKnightX = state[0], newKnightY = state[1],
    		monsterX = state[2], monsterY = state[3], 
    		goldX = state[4], goldY = state[5];
    	boolean gonnaGetEaten = false, gonnaGetGold = false;
    	int[] changeCoords = actionToDimensions(action);
    	dx = changeCoords[0];
    	dy = changeCoords[1];
    	newKnightX += dx;
    	newKnightY += dy;
    	
    	gonnaGetEaten = (Math.abs(newKnightX-monsterX) <= 1 || Math.abs(newKnightY-monsterY) <= 1);
    	gonnaGetGold = (newKnightX == goldX && newKnightY == goldY);
    	int deathPenalty = - ((MonsterAndKnightWorld)world).deathPenalty;
    	int treasureReward = ((MonsterAndKnightWorld)world).treasureReward;
    	if (gonnaGetEaten && gonnaGetGold)
    		return deathPenalty;
    	else if (gonnaGetEaten)
    		return deathPenalty;
    	else if (gonnaGetGold)
    		return treasureReward;
    	else
    		return 0;
    }
}