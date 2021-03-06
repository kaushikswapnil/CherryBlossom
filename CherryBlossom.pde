float g_MinBranchLength = 15.0f;
float g_BranchStrokeLengthMultiplier = 0.1f;
float g_BranchingMinMultiplier = 0.5f;
float g_BranchingMaxMultiplier = 0.85f;
float g_BranchingMaxWanderTheta = PI/4;
float g_InitialTreeLength = 150.0f;
float g_LeafSize = 8.0f;
float g_InitLeafSize = 1.0f;
float g_LeafMaxFrameGrowth = 0.03f;
float g_LeafGrowthProbability = 0.001f;
PVector g_LeafGravity = new PVector(0.0f, 1f);
float g_LeafTerminalVelocity = 2.0f;
int g_MaxLeafCount = 1;
float g_GroundHeight;
float g_GroundXStep = 8.0f;
float g_GroundPointSize = 2.0f;
//Branch g_Tree;
ArrayList<Leaf> g_FreeLeaves;
float g_LeafDropProbability = 0.0001f;
float g_LeafBelowGroundStopProbablity = 0.01f;
PImage g_BackgroundImg;
float g_WindForceMultiplier = 1.5f;
float g_BranchSwayMinLength = g_InitialTreeLength/2;
float g_BranchWindForceMultiplier = 0.007f;
float g_BranchStiffnessMultiplier = 0.008f;
float g_BranchAngVelDampingFactor = 0.95f;

ArrayList<Branch> g_Branches;

boolean g_Update = false;

int Y_AXIS = 1;
int X_AXIS = 2;

void setup()
{
  size(1200, 800);
  InitializeSystem();
}

void draw()
{
  if (!g_Update)
  {
   return; 
  }
  
  image(g_BackgroundImg, 0, 0);
  
  for (Branch branch : g_Branches)
  {
   branch.Update();
   branch.Draw();
  }
  
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

void InitializeSystem()
{
  g_FreeLeaves = new ArrayList<Leaf>();
  g_Branches = new ArrayList<Branch>();
  g_GroundHeight = 5*height/6;
  
  ArrayList<Integer> toProcess = new ArrayList<Integer>();
  g_Branches.add(new Branch(new PVector(width/2, g_GroundHeight), -PI/2, g_InitialTreeLength));
  toProcess.add(0);
  
  while(toProcess.size() != 0)
  {
   int parentBranch = toProcess.get(toProcess.size()-1);
   toProcess.remove(toProcess.size()-1);
   
   Branch parent = g_Branches.get(parentBranch);
   
   if (parent.Length > g_MinBranchLength)
   {
     PVector end = parent.GetEnd();
     
     int numBranches = (int)random(1, 5);
     while (numBranches-- > 0)
     {
      Branch subBranch = new Branch(end, parent.Angle + random(-g_BranchingMaxWanderTheta, g_BranchingMaxWanderTheta), parent.Length * random(g_BranchingMinMultiplier, g_BranchingMaxMultiplier));
      subBranch.Parent = parentBranch;
      toProcess.add(g_Branches.size());
      g_Branches.add(subBranch);
     }
   }
  }
  noiseSeed(0);
  
  CreateBackground();
  
  for (Branch branch : g_Branches)
  {
   branch.Draw(); 
  }
}

void CreateBackground()
{
  color skyBlue = color(51, 85, 255);
  color groundGrey = color(180, 180, 180);
  background(groundGrey); 
  
  SetGradient(0, 0, width, g_GroundHeight, skyBlue, groundGrey, Y_AXIS);
  
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

void SetGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

void keyPressed()
{
 if (key == 'r' || key == 'R')
 {
   InitializeSystem();
 }
 
 if (key == ' ')
 {
   g_Update = !g_Update;
 }
}
