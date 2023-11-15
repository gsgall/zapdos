//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "MultiplicationPostprocessor.h"

registerMooseObject("ZapdosApp", MultiplicationPostprocessor);

InputParameters
MultiplicationPostprocessor::validParams()
{
  InputParameters params = GeneralPostprocessor::validParams();
  params.addClassDescription("Multiply a post processor by a number");
  params.addParam<Real>("coeff", "The number to multiply the postprocessor value by");
  params.addParam<PostprocessorName>("value", "The name of the postprocessor");
  return params;
}

MultiplicationPostprocessor::MultiplicationPostprocessor(const InputParameters & parameters)
  : GeneralPostprocessor(parameters),
  _coeff(getParam<Real>("coeff")),
  _pps_value(getPostprocessorValue("value"))

{
}


void
MultiplicationPostprocessor::initialize()
{
}

void
MultiplicationPostprocessor::execute()
{
}

Real
MultiplicationPostprocessor::getValue() const
{
  return _pps_value * _coeff;
}
