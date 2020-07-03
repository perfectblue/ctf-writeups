struct node
{
  int field_0;
  int field_4;
  void (*executor)(struct node *, int);
  int jobs;
  struct node **child;
};

