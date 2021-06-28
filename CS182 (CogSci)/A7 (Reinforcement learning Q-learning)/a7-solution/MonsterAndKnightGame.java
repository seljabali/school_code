import java.awt.*;
import javax.swing.*;

public class MonsterAndKnightGame extends Thread {
	long delay;
	SwingApplet a;
	RLPolicy policy;
	MonsterAndKnightWorld world;
	static final int GREEDY=0, SMART=1; // type of knight to use
	int knighttype = SMART;
	
	public boolean gameOn = false, single=false, gameActive, newInfo = false;
	
	public MonsterAndKnightGame(SwingApplet s, long delay, MonsterAndKnightWorld w, RLPolicy policy) {
		world = w;
		
		a=s;
		this.delay = delay;
		this.policy = policy;
	}
	
	/* Thread Functions */
	public void run() {
		System.out.println("--Game thread started");
		// start game
		try {
			while(true) {
				while(gameOn) {
					gameActive = true;
					resetGame();
					SwingUtilities.invokeLater(a); // draw initial state
					runGame();
					gameActive = false;
					newInfo = true;
					SwingUtilities.invokeLater(a); // update state
					sleep(delay);
				}
				sleep(delay);
			}
		} catch (InterruptedException e) {
			System.out.println("interrupted.");
		}
		System.out.println("== Game finished.");
	}
	
	public void runGame() {
		while(!world.endGame()) {
			//System.out.println("Game playing. Making move.");
			int action=-1;
			if (knighttype == GREEDY) {
				action = world.knightAction();
			} else if (knighttype == SMART) {
				action = policy.getBestAction(world.getState());
			} else {
				System.err.println("Invalid knight type:"+knighttype);
			}
			world.getNextState(action);

			//a.updateBoard();
			SwingUtilities.invokeLater(a);
				
			try {
				sleep(delay);
			} catch (InterruptedException e) {
				System.out.println("interrupted.");
			}
		}
		a.knightscore += world.knightscore;
		a.monsterscore += world.monsterscore;
		
		// turn off gameOn flag if only single game
		if (single) gameOn = false;
	}
	
	public void interrupt() {
		super.interrupt();
		System.out.println("(interrupt)");
	}
	
	/* end Thread Functions */

	public void setPolicy(RLPolicy p) {	policy = p; }
	
	public Dimension getKnight() { return new Dimension(world.mx, world.my); }
	public Dimension getMonster() { return new Dimension(world.cx, world.cy); }
	public Dimension getTreasure() { return new Dimension(world.chx, world.chy); }
	public Dimension getHole() { return new Dimension(world.hx, world.hy); }
	public boolean[][] getWalls() { return world.walls; }
	
	public void makeMove() {
		world.moveKnight();
		world.moveMonster();
	}

	public void resetGame() {
		world.resetState();
	}
}

