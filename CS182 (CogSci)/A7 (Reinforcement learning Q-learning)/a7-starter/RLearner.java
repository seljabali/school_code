import java.util.HashMap;


/** A reinforcement learning agent. Your main class. */
public class RLearner {

    /** The world we live in */
    RLWorld thisWorld;

    /** Our current policy */
    RLPolicy policy;

    /** Epsilon for an epsilon-greedy policy */
    double epsilon;

    /** The learning rate */
    double alpha;

    /** The discounting rate */
    double gamma;

    /** Dimensions of the world */
    int[] dimSize;
    
    /** Number of actions (i.e. actions go 0,1,...,nActions-1) */
    int nActions;
    
    /** If the first epoch run */
    boolean firstRun, usedBestAction = false;
    
    int[] state = null;

    // stuff you don't need to worry about:
    public int epochsdone;
    public boolean running;
    long timer;

    public RLearner(RLWorld world) {
        // Getting the world from the invoking method.
        thisWorld = world;

        // Get dimensions of the world.
        dimSize = thisWorld.getDimension();
        nActions = dimSize[dimSize.length-1];

        // Creating new policy with dimensions to suit the world.
        this.policy = newPolicy();

        // set default values
        epsilon = 0.1;
        alpha = 1;
        gamma = 0.1;

        firstRun = true;
        
        System.out.println("RLearner initialized");

    }

    // execute one epoch
    public void runEpoch() {
    	int action; double reward;
    	usedBestAction = false;
    	
    	if (firstRun){
    		// Reset state to start position defined by the world.
    		//state = thisWorld.resetState();
    		state = ((MonsterAndKnightWorld)thisWorld).stateArray;
    		firstRun = false;
    	}
        
    	//Find best action
    	action = selectAction(state);
    	
    	//Apply it to world
        state = thisWorld.getNextState(action);

        //update R table with the new reward if we used BestAction
        reward = thisWorld.getReward();
        
        
        //if (thisWorld.endState() || (state[0] == state[4] && state[1] == state[5]))
        //	firstRun = true;
    } 
    
    
    
    /** Select an action via the epsilon-greedy method. */
    private int selectAction(int[] state) {

        int action;

        // Epsilon case: explore
       if (Math.random() < epsilon) 
            // System.out.println( "Exploring ..." );
           action = (int) (Math.random() * nActions);
        // Greedy case: take best action
       else 
            action = policy.getBestAction(state);        

        // Choose new action if not valid.
        while (!thisWorld.validAction(action)) { //May want to find the best valid one*

            action = (int) (Math.random() * nActions);
            System.out.println( "Invalid action, new one:" +  action);
         }

        return action;
    }

    public RLPolicy getPolicy() {
        return policy;
    }

    public void setAlpha(double a) {
        if (a >= 0 && a < 1)
            alpha = a;
    }

    public double getAlpha() {
        return alpha;
    }

    public void setGamma(double g) {
        if (g > 0 && g < 1)
            gamma = g;
    }

    public double getGamma() {
        return gamma;
    }

    public void setEpsilon(double e) {
        if (e > 0 && e < 1)
            epsilon = e;
    }

    public double getEpsilon() {
        return epsilon;
    }

    /** Reset our policy and Q-values */
    public RLPolicy newPolicy() {
        policy = new RLPolicy(dimSize, this);
        // Initializing the policy with the initial values defined by the world.
        // TODO: complete this! Initialize Q-values with thisWorld.getInitValues()
        return policy;
    }
    
    public RLWorld getWorld() { //Our method
    	return this.thisWorld;
    }
}
