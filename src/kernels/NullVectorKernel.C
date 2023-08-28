#include "NullVectorKernel.h"

registerADMooseObject("ZapdosApp", NullVectorKernel);

InputParameters
NullVectorKernel::validParams()
{
  auto params = ADKernel::validParams();
  params.addClassDescription("");
  params.addRequiredCoupledVar("velocity", "Velocity vector variable.");
  params.addRequiredParam<MaterialPropertyName>("coeff_name",
                                                "The coeff to multiply by the advection term");
  return params;
}

NullVectorKernel::NullVectorKernel(const InputParameters & parameters)
  : ADKernel(parameters), _velocity(adCoupledVectorValue("velocity"))
{
}

ADReal
NullVectorKernel::computeQpResidual()
{
  return 0.0;
}
