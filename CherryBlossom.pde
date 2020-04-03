float g_MinBranchLength = 15.0f;
float g_BranchStrokeLengthMultiplier = 0.1f;
float g_BranchingMinMultiplier = 0.5f;
float g_BranchingMaxMultiplier = 0.92f;
float g_BranchingMaxWanderTheta = PI/4;
float g_InitialTreeLength = 150.0f;
float g_LeafSize = 8.0f;
float g_InitLeafSize = 1.0f;
float g_LeafMaxFrameGrowth = 0.03f;
float g_LeafGrowthProbability = 0.001f;
PVector g_LeafGravity = new PVector(0.0f, 0.5f);
float g_LeafTerminalVelocity = 2.0f;
int g_MaxLeafCount = 1;
float g_GroundHeight;
float g_GroundXStep = 8.0f;
float g_GroundPointSize = 2.0f;
Branch g_Tree;
ArrayList<Leaf> g_FreeLeaves;
float g_LeafDropProbability = 0.0001f;
float g_LeafBelowGroundStopProbablity = 0.01f;
PImage g_BackgroundImg;
float g_NoiseMaxStrengthMultiplier = 10.0f;

void setup()
{
  size(1200, 800);
  g_FreeLeaves = new ArrayList<Leaf>();
  g_GroundHeight = 5*height/6;
  g_Tree = new Branch(new PVector(width/2, g_GroundHeight), -PI/2, g_InitialTreeLength);
  noiseSeed(0);
  
  //Create background
  CreateBackground();
}

void draw()
{
  //DrawBackground();
  image(g_BackgroundImg, 0, 0);
  g_Tree.Draw();
  g_Tree.Update();
  
  for (int leafIter = g_FreeLeaves.size()-1; leafIter >= 0; --leafIter)
  {
   Leaf freeLeaf = g_FreeLeaves.get(leafIter);
   if (freeLeaf.IsOutOfBounds())
   {
    g_FreeLeaves.remove(freeLeaf); 
   }
   else
   {
    freeLeaf.Draw();
    freeLeaf.Update(); 
   }
  }
}

void CreateBackground()
{
  background(240, 240, 240); 
  
  //Draw perforated ground
  stroke(10);
  fill(10);
  for (int Y = 0; (Y*g_GroundXStep) + g_GroundHeight < height; ++Y)
  {
    float y = (Y*g_GroundXStep) + g_GroundHeight;
    for (float x = (Y%2) * g_GroundXStep/2; x < width; x+= g_GroundXStep)
    {
      circle(x, y, g_GroundPointSize);
    }
  }
  
  save("bg.png");
  g_BackgroundImg = loadImage("bg.png");
}
