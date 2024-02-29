/*
 ComplexLib is a simple library for working with complex numbers in Processing Java.
 It currently implements the following operators and functions:
 
 Addition
 Subtraction
 Multiplication
 Reciprocation
 Division
 Exponentiation (limited to natural exponents)
 Normalization
 Conjugates
 Polar coordinates
 Square roots
*/


//base class representing complex numbers. Implements some operators/functions for convenience.
class Complex {
  double r; //real part
  double i; //imaginary part

  Complex(double r_, double i_) {
    r = r_;
    i = i_;
  }

  //get real dude, smh rn
  double getReal() {
    return r;
  }

  double getImaginary() {
    return i;
  }

  double getMagnitude() {
    return Math.sqrt( r*r + i*i );
  }

  boolean equals(Complex c) {
    return r == c.r && i == c.i;
  }

  String toString() {
    return "("+r+" + "+i+"i)";
  }

  //literally no idea if this even works, no time to test it
  void normalize() {
    r /= getMagnitude();
    i /= getMagnitude();
  }

  void add(Complex c) {
    r += c.r;
    i += c.i;
  }

  void subtract(Complex c) {
    r -= c.r;
    i -= c.i;
  }

  void multiply(double a) {
    r *= a;
    i *= a;
  }

  void multiply(Complex c) {
    r = r * c.r - i * c.i;
    i = r * c.i + i * c.r;
  }

  double getPhase() {
    return Math.atan2(r, i);
  }

  Complex getConjugate() {
    return complex(r, -i);
  }

  //from complexnumbers211235857.wordpress.com/2020/08/03/multiplicative-inverse-and-reciprocal-of-a-complex-number
  Complex getReciprocal() {
    double s = r*r + i*i;
    return complex(r/s, -i/s);
  }
  
  void square() {
    multiply(complex(r, i));
  }

  void raise(int exponent) {
    if (exponent < 0) {
      println("WARNING: ComplexLib: Exponentiation with a negative exponent is not supported and always yields 0r + 0i");
      r = 0;
      i= 0;
      return;
    }

    exponent--;

    while (exponent > 0) {
      multiply(this);
      exponent--;
    }
  }
}





final Complex cZero = new Complex(0, 0);

boolean cEquals(Complex a, Complex b) {
  return a.r == b.r && a.i == b.i;
}

String cToString(Complex c) {
  return c.toString();
}

//shorthand for "new Complex()"
Complex complex(double r, double i) {
  return new Complex(r, i);
}

//useful when you want to do things like adding a real number to a complex number even though there is no function that explicitly supports it
Complex complex(double r) {
  return complex(r, 0);
}

double cPhase(Complex input) {
  return Math.atan2(input.r, input.i);
}

Complex cConjugate(Complex c) {
  return c.getConjugate();
}

Complex cReciprocal(Complex c) {
  return c.getReciprocal();
}

Complex cAdd(Complex a, Complex b) {
  return complex(a.r+b.r, a.i+b.i);
}

//same shit again but with three (convenience)
Complex cAdd(Complex a, Complex b, Complex c) {
  return complex(a.r+b.r+c.r, a.i+b.i+c.i);
}

Complex cSum(Complex[] input) {
  double rSum = 0;
  double iSum = 0;
  for (int i = 0; i < input.length; i++) {
    rSum += input[i].r;
    iSum += input[i].i;
  }
  Complex output = complex(rSum, iSum);
  return output;
}

Complex cSubtract(Complex a, Complex b) {
  return complex(a.r-b.r, a.i-b.i);
}

Complex cMultiply(Complex c, double alpha) {
  return complex(c.r*alpha, c.i*alpha);
}

Complex cMultiply(double alpha, Complex c) {
  return complex(c.r*alpha, c.i*alpha);
}

Complex cMultiply(Complex a, Complex b) {
  double r = a.r * b.r - a.i * b.i;
  double i = a.r * b.i + a.i * b.r;
  return complex(r, i);
}

Complex cDivide(Complex a, double b) {
  return complex(a.r/b, a.i/b);
}

Complex cDivide(Complex a, Complex b) {
  return cMultiply(a, cReciprocal(b));
}

Complex cSquare(Complex input) {
  return cMultiply(input, input);
}

//can only do exponentiation with a natural exponent. TESTME
Complex cRaise(Complex base, int exponent) {
  if (exponent < 0) {
    println("WARNING: ComplexLib: Exponentiation with a negative exponent is not supported and always yields 0r + 0i");
    return cZero;
  }

  exponent--;  //this seems to work but it's really awful
  Complex result = base;

  while (exponent > 0) {
    result = cMultiply(result, base);
    exponent--;
  }

  return result;
}

//TESTME
Complex cSqrt(Complex input) {
  double r = Math.sqrt(input.getMagnitude());
  double theta = cPhase(input)/2;
  return complex(r*Math.cos(theta), r*Math.sin(theta));
}

//TESTME
Complex normalize(Complex c) {
  return complex(c.r /= c.getMagnitude(), c.i /= c.getMagnitude());
}





//--------------TESTING ONLY--------------//

double precision = 0.00001; //how much the expected and the calculated result are allowed to diverge

//i used symbolab.com/solver/complex-numbers-calculator and WolframAlpha to calculate these
void cTest() {
  println("starting test...");
  
  test("Equals", cEquals(c(1, 23), c(1, 23)));
  test("Addition", eq( cAdd(c(5, 6), c(2, 1)), c(7, 7)) );
  test("Subtraction", eq( cSubtract(c(12.4, 5), c(11.2, 4.9)), c(1.2, 0.1)) );
  test("Multiplication", eq( cMultiply(c(5.1, 6.3), c(2, -1)), c(16.5, 7.5)));
  test("Reciprocation", eq( complex(3, -2).getReciprocal(), c(0.230769230, 0.1538461538) ));
  test("Division", eq( cDivide(c(1, 2), c(2, 3)), c(0.615384615, 0.07692)));
  test("Exponentiation", eq(cRaise(c(5, 7), 3), c(-610, 182)));
  
  println("\n");
  println(total + " tests have been performed. " + passed + " passed, " + failed + " failed.");
}

//shorthands for testing
Complex c(double r, double i) {
  return complex(r, i);
}
boolean eq(Complex a, Complex b) {
  return Math.abs(a.r-b.r)<precision&&Math.abs(a.i-b.i)<precision;
}

//weird generic test thingy
int passed = 0;
int failed = 0;
int total = 0;

void test(String name, boolean b) { //i tried to refactor it a bit and now it's even less readable. success!
  total++;
  print("\ntestcase \"" + name);
  if (!b) {
    print("\" failed");
    failed++;
    return;
  }
  passed++;
  print("\" passed");
}
