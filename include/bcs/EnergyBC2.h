#pragma once

#include "ADIntegratedBC.h"

class EnergyBC2 : public ADIntegratedBC
{
public:
  static InputParameters validParams();

  EnergyBC2(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  Real _time_units;
  Real _r_units;
  Real _r;

  // Coupled variables

  const ADVariableGradient & _grad_potential;
  unsigned int _potential_id;
  const ADVariableValue & _em;
  unsigned int _em_id;
  MooseVariable & _ip_var;
  const ADVariableValue & _ip;
  const ADVariableGradient & _grad_ip;
  unsigned int _ip_id;

  unsigned int _nargs;
  std::vector<const ADVariableValue *> _args;
  std::vector<const ADVariableGradient *> _grad_args;
  std::vector<unsigned int> _args_id;
  std::vector<const MaterialProperty<Real> *> _sgnion;
  std::vector<const ADMaterialProperty<Real> *> _muion;
  std::vector<const ADMaterialProperty<Real> *> _Dion;

  const ADMaterialProperty<Real> & _muem;
  // const MaterialProperty<Real> & _d_muem_d_actual_mean_en;
  const MaterialProperty<Real> & _massem;
  const MaterialProperty<Real> & _e;
  const MaterialProperty<Real> & _sgnip;
  const ADMaterialProperty<Real> & _muip;
  const ADMaterialProperty<Real> & _Dip;
  const MaterialProperty<Real> & _se_coeff;
  const MaterialProperty<Real> & _se_energy;
  const ADMaterialProperty<Real> & _mumean_en;

  Real _a;
  ADReal _v_thermal;
  ADRealVectorValue _ion_flux;
  Real _n_gamma;
  // Real _d_v_thermal_d_u;
  // Real _d_v_thermal_d_em;
  // RealVectorValue _d_ion_flux_d_potential;
  // RealVectorValue _d_ion_flux_d_ip;
  // Real _d_n_gamma_d_potential;
  // Real _d_n_gamma_d_ip;
  // Real _d_n_gamma_d_u;
  // Real _d_n_gamma_d_em;
  Real _actual_mean_en;
};

