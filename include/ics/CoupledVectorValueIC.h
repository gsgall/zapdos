//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "VectorInitialCondition.h"
#include "Function.h"

// System includes
#include <string>

class InputParameters;

namespace libMesh
{
class Point;
}

/**
 * IC that calls vectorValue method of a Function object.
 */
class CoupledVectorValueIC : public VectorInitialCondition
{
public:
  static InputParameters validParams();

  CoupledVectorValueIC(const InputParameters & parameters);

  virtual RealVectorValue value(const Point & /*p*/) override;

protected:
  /// Optional component function value
  const VariableValue & _x;
  const VariableValue & _y;
  const VariableValue & _z;
};
