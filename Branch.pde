class Branch
{
  ArrayList<Branch> SubBranches;
  ArrayList<Leaf> Leaves;
  PVector Start;
  float Angle;
  float Angle0, Angle1;
  int SwayDir;
  float SwayGrad;
  float Length;
  
  Branch(PVector start, float angle, float size)
  {
   Start = start.copy();
   Angle = Angle0 = Angle1 = angle;
   SwayDir = 0;
   SwayGrad = 0.0f;
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
   
   if (Length <= g_BranchSwayMinLength)
   {
    float swayAngle = g_BranchMaxSwayAngle * (1.0f - (Length/(g_BranchSwayMinLength)));
    Angle0 = Angle - swayAngle;
    Angle1 = Angle + swayAngle;
   }
  }
  
  void Draw()
  {
   pushMatrix();
   translate(Start.x, Start.y);
   rotate(Angle);
   stroke(68, 38, 11);
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
    
    boolean canbewindAffected = CanBeWindAffected();
    if (canbewindAffected)
    {
      if (SwayDir == 0)
      {
        Angle = lerp(Angle0, Angle1, SwayGrad);
      }
      else
      {
        Angle = lerp(Angle1, Angle0, SwayGrad);
      }
      
      SwayGrad += 0.05f;
      if (SwayGrad>=0.98f)
      {
       SwayDir = (SwayDir+1)%2; 
       SwayGrad = 0.0f;
      }
    }
    
    if (canbewindAffected)
    {
      PVector end = GetEnd();
      for (Branch branch: SubBranches)
      {
         branch.Start = end;
         branch.Update();
      }
      
      for (Leaf leaf : Leaves)
      {
        leaf.Pos = end;
        leaf.Update(); 
      } 
    }
    else
    {
      for (Branch branch: SubBranches)
      {
         branch.Update();
      }
      
      for (Leaf leaf : Leaves)
      {
        leaf.Update(); 
      } 
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
  
  boolean CanBeWindAffected()
  {
   //return Angle0 != Angle1;
   return false;
  }
}
