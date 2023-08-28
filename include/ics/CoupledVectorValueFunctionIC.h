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

class Function;

class CoupledVectorValueFunctionIC : public VectorInitialCondition
{
public:
  static InputParameters validParams();

  CoupledVectorValueFunctionIC(const InputParameters & parameters);

  virtual RealVectorValue value(const Point & /*p*/) override;

protected:
  const Function & _func_x;
  const Function & _func_y;
  const Function & _func_z;
  const unsigned int _var_num;
  const std::vector<const VariableValue *> _vals;
};
