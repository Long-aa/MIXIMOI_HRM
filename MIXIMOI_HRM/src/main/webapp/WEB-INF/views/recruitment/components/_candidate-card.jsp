<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Component: _candidate-card.jsp -- Thẻ ứng viên trên Kanban board --%>
<div class="kanban-card ${selectedCandidate.id == c.id ? 'active-card' : ''}"
    draggable="true" 
    ondragstart="handleDragStart(event)"
    ondragend="handleDragEnd(event)"
    onclick="selectCandidateCard(this)" 
    data-id="${c.id}"
    data-code="${c.candidateCode}" 
    data-name="${c.fullName}"
    data-email="${c.email}" 
    data-phone="${c.phone}"
    data-job="${c.jobTitle}" 
    data-source="${c.source}"
    data-stage="${c.stage}" 
    data-exp="${c.experienceYears}"
    data-salary="${c.formattedSalary}"
    data-score="${c.aiMatchScore}" 
    data-rating="${c.rating}"
    data-avatar="${c.avatarInitials}"
    data-skills="${c.skills}"
    data-matched="${c.aiMatchedSkills}"
    data-missing="${c.aiMissingSkills}"
    data-rec="${c.aiRecommendation}"
    data-edu="${c.education}" 
    data-work="${c.workHistory}">

    <div class="d-flex justify-content-between align-items-start mb-2">
        <span class="badge ${c.stage == 'NEW' ? 'bg-secondary-subtle text-secondary' : (c.stage == 'SCREENING' ? 'bg-warning-subtle text-warning' : (c.stage == 'INTERVIEW' ? 'bg-primary-subtle text-primary' : (c.stage == 'OFFER' ? 'bg-info-subtle text-info' : 'bg-success-subtle text-success')))}">${c.jobTitle}</span>
        <span class="badge bg-light text-dark border">
            <i class="bi bi-robot text-primary me-1"></i>${c.aiMatchScore}%
        </span>
    </div>
    <div class="fw-bold text-dark" style="font-size: 0.9rem;">${c.fullName}</div>
    <div class="text-muted small mb-2 text-truncate" style="max-width: 220px;">${c.skills}</div>
    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
        <span class="text-warning small">
            <i class="bi bi-star-fill"></i> ${c.rating}
        </span>
        <span class="badge bg-light text-muted border">${c.source}</span>
    </div>
</div>
