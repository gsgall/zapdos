//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CoupledVectorValueFunctionIC.h"
#include "Function.h"

registerMooseObject("ZapdosApp", CoupledVectorValueFunctionIC);

InputParameters
CoupledVectorValueFunctionIC::validParams()
{
  InputParameters params = VectorInitialCondition::validParams();
  params.addClassDescription("Initialize the variable from a lookup function");
  params.addRequiredParam<FunctionName>("function_x",
                                        "Coupled function to evaluate with values from v");
  params.addRequiredParam<FunctionName>("function_y",
                                        "Coupled function to evaluate with values from v");
  params.addRequiredParam<FunctionName>("function_z",
                                        "Coupled function to evaluate with values from v");
  params.addCoupledVar("v",
                       "List of up to four coupled variables that are substituted for x,y,z, and t "
                       "in the coupled function");
  return params;
}

CoupledVectorValueFunctionIC::CoupledVectorValueFunctionIC(const InputParameters & parameters)
  : VectorInitialCondition(parameters),
    _func_x(getFunction("function_x")),
    _func_y(getFunction("function_y")),
    _func_z(getFunction("function_z")),
    _var_num(coupledComponents("v")),
    _vals(coupledValues("v"))
{
  if (_var_num > 4)
    paramError("v", "You can couple at most four variables.");
}

RealVectorValue
CoupledVectorValueFunctionIC::value(const Point & /*p*/)
{
  Point p;
  Real t = 0.0;

  for (unsigned int i = 0; i < 3 && i < _var_num; ++i)
    p(i) = (*_vals[i])[_qp];
  if (_var_num == 4)
    t = (*_vals[3])[_qp];

  return RealVectorValue(_func_x.value(t, p), _func_y.value(t, p), _func_z.value(t, p));
}
