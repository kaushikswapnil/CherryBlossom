class Branch
{
  ArrayList<Branch> SubBranches;
  ArrayList<Leaf> Leaves;
  PVector Start;
  float Angle;
  float Length;
  
  Branch(PVector start, float angle, float size)
  {
   Start = start.copy();
   Angle = angle;
   Length = size;
   SubBranches = new ArrayList<Branch>();
   Leaves = new ArrayList<Leaf>();
   
   if (Length > g_MinBranchLength)
   {
     PVector end = GetEnd();
     
     int numBranches = (int)random(1, 5);
     while (numBranches-- > 0)
     {
      SubBranches.add(new Branch(end, Angle + random(-g_BranchingMaxWanderTheta, g_BranchingMaxWanderTheta), Length * random(g_BranchingMinMultiplier, g_BranchingMaxMultiplier))); 
     }
   }
  }
  
  void Draw()
  {
   pushMatrix();
   translate(Start.x, Start.y);
   rotate(Angle);
   stroke(139, 69, 19);
   strokeWeight(Length * g_BranchStrokeLengthMultiplier);
   line(0, 0, Length, 0);
   popMatrix();
   
   for (Branch branch: SubBranches)
   {
     branch.Draw();
   }
   
   for (Leaf leaf : Leaves)
   {
    leaf.Draw(); 
   }
  }
  
  void Update()
  {
    if (IsLeaf())
    {
     if (Leaves.size() < g_MaxLeafCount)
     {
       if (random(0, 1) < g_LeafGrowthProbability)
       {
         int numLeaves = (int)random(1, 5);
         PVector end = GetEnd();
         while(numLeaves-- > 0)
         {
           Leaves.add(new Leaf(end));
         }
       }
     }
     else if (Leaves.get(Leaves.size()-1).IsFullyGrown() && random(0, 1) < g_LeafDropProbability)
     {
       //drop the leaf
       Leaf lastLeaf = Leaves.get(Leaves.size()-1);
       g_FreeLeaves.add(new Leaf(lastLeaf.Pos, true, lastLeaf.Size));
       Leaves.remove(lastLeaf);
     }
    }
    
    for (Branch branch: SubBranches)
    {
       branch.Update();
    }
    
    for (Leaf leaf : Leaves)
    {
      leaf.Update(); 
    }
  }
  
  boolean IsLeaf()
  {
   return Length <= g_MinBranchLength; 
  }
  
  PVector GetEnd()
  {
    PVector end = PVector.add(Start, PVector.mult(PVector.fromAngle(Angle), Length));
    return end;
  }
}
