#include "ADMatAdvection.h"

registerADMooseObject("ZapdosApp", ADMatAdvection);

InputParameters
ADMatAdvection::validParams()
{
  auto params = ADKernel::validParams();
  params.addClassDescription("");
  params.addRequiredCoupledVar("velocity", "Velocity vector variable.");
  params.addRequiredParam<MaterialPropertyName>("coeff_name",
                                                "The coeff to multiply by the advection term");
  return params;
}

ADMatAdvection::ADMatAdvection(const InputParameters & parameters)
  : ADKernel(parameters),
    _velocity(adCoupledVectorValue("velocity")),
    _coeff(getADMaterialProperty<Real>("coeff_name"))
{
}

ADReal
ADMatAdvection::computeQpResidual()
{
  return -_grad_test[_i][_qp] * _coeff[_qp] * _u[_qp] * _velocity[_qp];
}
