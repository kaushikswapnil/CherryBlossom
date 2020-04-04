class Branch
{
  ArrayList<Leaf> Leaves;
  PVector Start;
  float Angle;
  float Angle0;
  float PrevAngle;
  int SwayDir;
  float SwayGrad;
  float Length;
  int Parent;
  
  Branch(PVector start, float angle, float size)
  {
   Start = start.copy();
   Angle = Angle0 = PrevAngle = angle;
   SwayDir = 0;
   SwayGrad = 0.0f;
   Length = size;
   Parent = -1;
   Leaves = new ArrayList<Leaf>();
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
    
    boolean canBeWindAffected = CanBeWindAffected();
    if (canBeWindAffected)
    {
      //Get parents start position and update self
      if (g_Branches.get(Parent).CanBeWindAffected())
      {
       Start = g_Branches.get(Parent).GetEnd();
      }
      
      PVector end = GetEnd();
      
      float noiseAtEndPos = noise(end.x, end.y, frameCount/1000);
      float angAcc = noiseAtEndPos > 0.5f ? (noiseAtEndPos < 0.75f ? -g_BranchWindForceAngAcc : g_BranchWindForceAngAcc) : 0.0f;
      
      float dispAngles = Angle0 - Angle;
      float distAngles = abs(dispAngles);
      
      float resistance = distAngles * g_BranchStiffnessMultiplier * (dispAngles < 0.0 ? -1.0f : 1.0f);
      angAcc += resistance;
      
      float angVel = (Angle - PrevAngle)*g_BranchAngVelDampingFactor;
      angVel += angAcc;
      
      PrevAngle = Angle;
      Angle += angVel;
      
      end = GetEnd();
      for (Leaf leaf : Leaves)
      {
       leaf.Pos = end.copy();
       leaf.Update(); 
      }
    }
    else
    {
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
  
  PVector GetIdealEnd()
  {
    PVector end = PVector.add(Start, PVector.mult(PVector.fromAngle(Angle0), Length));
    return end;
  }
  
  boolean CanBeWindAffected()
  {
   return Length <= g_BranchSwayMinLength;
  }
}
