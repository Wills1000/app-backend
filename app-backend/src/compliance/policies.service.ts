import { Injectable, ForbiddenException, BadRequestException } from '@nestjs/common';

@Injectable()
export class PoliciesService {
  getTermsOfService() {
    return {
      version: '1.0.0',
      effectiveDate: '2026-01-01',
      jurisdiction: 'Federal Republic of Nigeria',
      content: 'By accessing or using the platform, you agree to be bound by these Terms. Wagering is restricted to users 18 years of age and older...',
    };
  }

  getPrivacyPolicy() {
    return {
      version: '1.0.0',
      dataController: 'Gamer App Platform',
      compliance: 'Nigeria Data Protection Regulation (NDPR) compliant',
      content: 'We collect personal data strictly for account authentication, wallet ledger security, and anti-fraud verification...',
    };
  }

  verifyUserEligibility(dto: { age: number; countryCode: string; acceptedTerms: boolean }) {
    if (!dto.acceptedTerms) {
      throw new BadRequestException('You must accept the Terms of Service and Privacy Policy to continue.');
    }
    if (dto.age < 18) {
      throw new ForbiddenException('Access denied: You must be at least 18 years old to participate in wagering.');
    }
    if (dto.countryCode !== 'NG') {
      // Handle cross-border limitations or restrictions
      throw new ForbiddenException('Platform services are currently restricted outside of the permitted jurisdiction.');
    }
    return { eligible: true, status: 'VERIFIED' };
  }
}