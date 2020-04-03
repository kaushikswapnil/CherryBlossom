class Leaf
{
  PVector Pos;
  PVector Vel;
  boolean Free;
  float Size;
  
  Leaf(PVector pos)
  {
   Pos = pos.copy(); 
   Vel = new PVector(0, 0);
   Free = false;
   Size = g_InitLeafSize;
  }
  
  Leaf(PVector pos, boolean free, float size)
  {
   Pos = pos.copy(); 
   Vel = new PVector(0, 0);
   Free = free;
   Size = size;
  }
  
  void Update()
  {
    if (Free)
    {
      PVector acc = PVector.add(g_LeafGravity, PVector.mult(PVector.fromAngle(map(noise(Pos.x, Pos.y, frameCount/100), 0.0, 1.0, 0.0, TWO_PI)), g_WindForceMultiplier));
      Vel.add(acc);
      if (Vel.mag() > g_LeafTerminalVelocity)
      {
       Vel.normalize();
       Vel.mult(g_LeafTerminalVelocity);
      }
      
      Pos.add(Vel);
      
      if (IsBelowGroundHeight() && random(0, 1) < g_LeafBelowGroundStopProbablity)
      {
        Free = false;
      }
    }
    else
    {
      if (!IsFullyGrown())
      {
       Size += random(0.0f, g_LeafMaxFrameGrowth); 
      } 
    }
  }
  
  void Draw()
  {
    stroke(255, 182, 193);
    fill(255, 182, 193);
    circle(Pos.x, Pos.y, Size);
  }
  
  boolean IsFullyGrown()
  {
    return Size >= g_LeafSize;
  }
  
  boolean IsBelowGroundHeight()
  {
   return Pos.y >= g_GroundHeight; 
  }
  
  boolean IsOutOfBounds()
  {
    return Pos.x > width || Pos.x < 0.0f || Pos.y < 0.0f || Pos.y > height;
  }
}
