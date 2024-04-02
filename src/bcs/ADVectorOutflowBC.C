//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADVectorOutflowBC.h"

registerMooseObject("ZapdosApp", ADVectorOutflowBC);

InputParameters
ADVectorOutflowBC::validParams()
{
  InputParameters params = ADVectorIntegratedBC::validParams();
  params.addClassDescription(
      "Enforces a fluid is only flowing out of the domain");
  return params;
}

ADVectorOutflowBC::ADVectorOutflowBC(const InputParameters & parameters)
  : ADVectorIntegratedBC(parameters)
{
}

ADReal
ADVectorOutflowBC::computeQpResidual()
{
  if (_normals[_qp] * _u[_qp] > 0.0)
  {
    return _test[_i][_qp] * _u[_qp];
  }
  return 0.0;
}
