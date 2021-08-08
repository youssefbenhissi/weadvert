import { NgModule, Component } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { RegistreComponent } from './registre/registre.component';
import { LoginComponent } from './login/login.component';
import { AdminComponent } from './admin/admin.component';
import { TestComponent } from './test/test.component';
import { RegisterAgenciesComponent } from './register-agencies/register-agencies.component';
import { LoginAgenciesComponent } from './login-agencies/login-agencies.component';
import { ProfilAgenciesComponent } from './profil-agencies/profil-agencies.component';
import { CandidatureComponent } from './candidature/candidature.component';
import { DashboardAgenciesComponent } from './dashboard-agencies/dashboard-agencies.component';
import { EmailAutomobilisteComponent } from './email-automobiliste/email-automobiliste.component';
import { ResetPasswordComponent } from './reset-password/reset-password.component';
import { TrakingComponent } from './traking/traking.component';
import { AddoffreComponent } from './addoffre/addoffre.component';
const routes: Routes = [
  {path: '' , component: HomeComponent},
  {path: 'login', component: LoginComponent},

  {path: 'registre', component: RegistreComponent},
  {path: 'registre-agencies', component: RegisterAgenciesComponent},
  {path: 'login-agencies', component: LoginAgenciesComponent},
  {path: 'profil', component: AdminComponent},
  {path: 'profil-agencies', component: ProfilAgenciesComponent},
  {path: 'liste-candidature/:idOffre', component: CandidatureComponent},
  {path:'dashboard-agencies',component:DashboardAgenciesComponent},
  {path:'email-automobiliste',component:EmailAutomobilisteComponent},
  {path:'reset-password-automobiliste',component:ResetPasswordComponent},
  {path:'traking',component:TrakingComponent},
  {path:'addoffres',component:AddoffreComponent}

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],






exports: [RouterModule]
})
export class AppRoutingModule { }
