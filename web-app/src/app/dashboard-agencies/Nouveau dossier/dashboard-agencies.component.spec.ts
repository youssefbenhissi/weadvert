import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DashboardAgenciesComponent } from './dashboard-agencies.component';

describe('DashboardAgenciesComponent', () => {
  let component: DashboardAgenciesComponent;
  let fixture: ComponentFixture<DashboardAgenciesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DashboardAgenciesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DashboardAgenciesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
