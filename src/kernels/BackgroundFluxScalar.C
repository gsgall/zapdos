//* This file is part of Zapdos, an open-source
//* application for the simulation of plasmas
//* https://github.com/shannon-lab/zapdos
//*
//* Zapdos is powered by the MOOSE Framework
//* https://www.mooseframework.org
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "BackgroundFluxScalar.h"

registerADMooseObject("ZapdosApp", BackgroundFluxScalar);

InputParameters
BackgroundFluxScalar::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addRequiredCoupledVar("u", "The x component of velocity");
  params.addCoupledVar("v", 0, "The y component of velocity");
  params.addCoupledVar("w", 0, "The z component of velocity");
  params.addClassDescription("Provides a flux term in with the strong form $u \\vec{v}$."
                             "Densities must be in log form."
                             "This kernel expects scalar velocity components.");
  return params;
}

BackgroundFluxScalar::BackgroundFluxScalar(const InputParameters & parameters)
  : ADKernel(parameters),
    _v_x(adCoupledValue("u")),
    _v_y(adCoupledValue("v")),
    _v_z(adCoupledValue("w"))
{
}

ADReal
BackgroundFluxScalar::computeQpResidual()
{
  return -_grad_test[_i][_qp] * std::exp(_u[_qp]) *
         ADRealVectorValue(_v_x[_qp], _v_y[_qp], _v_z[_qp]);
}
